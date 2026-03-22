import SwiftUI
import Combine

// MARK: - Session state

enum SessionState {
    case idle       // no session has been started
    case active     // session in progress (includes 2-second start buffer)
    case paused     // user navigated to Home mid-session
    case completed  // timer ran to zero; summary shown
}

// MARK: - GameViewModel

@MainActor
final class GameViewModel: ObservableObject {
    @Published var phase: GamePhase = .playing
    @Published var successMessage: String? = nil
    @Published var currentStepIndex: Int = 0
    @Published var correctItemID: UUID? = nil
    @Published var errorItemID: UUID? = nil
    @Published private(set) var currentLevelIndex: Int = 0
    @Published var feedbackMessage: String? = nil
    @Published var feedbackKind: FeedbackKind = .neutral

    // MARK: - Session tracking

    @Published private(set) var sessionState:  SessionState = .idle
    @Published private(set) var timeRemaining: TimeInterval = 600
    @Published private(set) var sessionEnded:  Bool = false
    @Published private(set) var lastRecord:    SessionRecord? = nil

    private var correctTaps:      Int = 0
    private var totalTaps:        Int = 0
    private var levelsCompleted:  Int = 0
    private var visitedSetNames:  [String] = []   // ordered, deduplicated on append
    private var sessionStartDate  = Date()
    private var sessionTimer:     Timer? = nil

    // MARK: - Game state

    private var lastCorrectMessage:    String? = nil
    private var lastErrorMessage:      String? = nil
    private var lastCompletionMessage: String? = nil

    @Published var hintItemID: UUID? = nil

    private var hintArmWork: DispatchWorkItem? = nil
    private var hintWork1:   DispatchWorkItem? = nil
    private var hintWork2:   DispatchWorkItem? = nil
    private var hintWork3:   DispatchWorkItem? = nil

    private var currentSetIndex: Int = 0
    private var currentSet: ContentSet { ItemLibrary.allSets[currentSetIndex] }
    private var themeLevels: [MissionLevel] = LevelData.levels(for: ItemLibrary.allSets[0])

    var level: MissionLevel { themeLevels[currentLevelIndex] }
    var isLastLevel: Bool { currentLevelIndex == themeLevels.count - 1 }
    var levelCount: Int { themeLevels.count }

    /// The theme currently in play, or nil when no session is running.
    /// Used by ParentView to lock the active theme's toggle mid-session.
    var activeTheme: ThemeType? {
        guard sessionState == .active || sessionState == .paused else { return nil }
        return currentSet.theme
    }

    var displayInstruction: String? {
        if isInStartBuffer { return startBufferMessage }
        return successMessage ?? currentStep?.instruction
    }

    var currentStep: MissionStep? {
        guard currentStepIndex < level.steps.count else { return nil }
        return level.steps[currentStepIndex]
    }

    /// "4:12 left" — shown in the top bar
    var timeRemainingText: String {
        let t = max(0, Int(timeRemaining))
        return String(format: "%d:%02d left", t / 60, t % 60)
    }

    private var isFeedbackActive: Bool { correctItemID != nil || errorItemID != nil }

    // MARK: - Start buffer

    /// True during the 2-second silent window after tapping Start.
    @Published private(set) var isInStartBuffer:    Bool    = false
    /// "Session Started" for the first second; nil during the fade-out second.
    @Published private(set) var startBufferMessage: String? = nil
    private var startBufferWork: DispatchWorkItem? = nil

    // MARK: - Session lifecycle

    /// Resets all session and game state, then waits 2 seconds before starting
    /// the countdown timer and playing the first instruction audio.
    /// Called when "Start" is tapped or "Practice Again" is chosen.
    func startSession() {
        // Cancel any in-flight start buffer
        startBufferWork?.cancel()
        startBufferWork = nil

        // Stop anything in progress
        sessionTimer?.invalidate()
        sessionTimer = nil
        cancelHints()
        VoiceManager.shared.stop()

        // Session metrics
        let store = SessionStore.shared
        timeRemaining    = store.selectedDuration.seconds
        sessionStartDate = Date()
        correctTaps      = 0
        totalTaps        = 0
        levelsCompleted  = 0
        visitedSetNames  = []
        sessionEnded     = false
        lastRecord       = nil

        // Pick starting set: first enabled theme, defaulting to 0
        currentSetIndex = firstEnabledSetIndex()
        themeLevels     = LevelData.levels(for: currentSet)
        recordVisit()

        // Game state
        correctItemID    = nil
        errorItemID      = nil
        feedbackMessage  = nil
        feedbackKind     = .neutral
        successMessage   = nil
        currentStepIndex = 0
        currentLevelIndex = 0
        phase            = .playing
        sessionState     = .active

        // 2-second buffer before gameplay begins:
        //   t=0s  "Session Started" appears in the instruction area
        //   t=1s  "Session Started" fades out over 1 second (message set to nil)
        //   t=2s  real instruction, audio, and timer all start together
        isInStartBuffer    = true
        startBufferMessage = "Session Started"

        // t=1s: begin fade-out by clearing the message
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self, self.isInStartBuffer else { return }
            self.startBufferMessage = nil
        }

        // t=2s: end buffer and start real gameplay
        let work = DispatchWorkItem { [weak self] in
            guard let self else { return }
            self.isInStartBuffer    = false
            self.startBufferWork    = nil
            self.speakLevelInstruction()
            self.scheduleSessionTimer()
        }
        startBufferWork = work
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: work)
    }

    private func scheduleSessionTimer() {
        sessionTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self else { return }
            Task { @MainActor in self.tick() }
        }
    }

    private func tick() {
        guard !sessionEnded else { return }
        timeRemaining -= 1
        if timeRemaining <= 0 {
            timeRemaining = 0
            finishSession()
        }
    }

    private func finishSession() {
        startBufferWork?.cancel()
        startBufferWork = nil
        isInStartBuffer = false
        sessionTimer?.invalidate()
        sessionTimer = nil
        cancelHints()
        VoiceManager.shared.stop()

        let store = SessionStore.shared
        let record = SessionRecord(
            id: UUID(),
            date: sessionStartDate,
            selectedMinutes: store.selectedDuration.rawValue,
            secondsPlayed: store.selectedDuration.seconds,   // timer ran to zero
            levelsCompleted: levelsCompleted,
            correctTaps: correctTaps,
            totalTaps: totalTaps,
            themes: visitedSetNames
        )
        store.add(record)
        lastRecord   = record
        sessionEnded = true
        sessionState = .completed
    }

    /// Pauses an active session when the user navigates to Home.
    /// Stops the timer, audio, and hints without discarding any progress.
    func pauseSession() {
        guard sessionState == .active else { return }
        startBufferWork?.cancel()
        startBufferWork    = nil
        isInStartBuffer    = false
        startBufferMessage = nil
        sessionTimer?.invalidate()
        sessionTimer = nil
        cancelHints()
        VoiceManager.shared.stop()
        sessionState = .paused
    }

    /// Resumes a paused session. Re-speaks the current instruction and
    /// restarts the countdown from the remaining time.
    func resumeSession() {
        guard sessionState == .paused else { return }
        sessionState = .active
        speakLevelInstruction()
        scheduleSessionTimer()
    }

    // MARK: - Gameplay

    func itemTapped(_ item: PlayItem) {
        cancelHints()
        guard phase == .playing, !isFeedbackActive,
              !sessionEnded, let step = currentStep else { return }

        totalTaps += 1

        if item.id == step.targetItemID {
            correctTaps += 1
            correctItemID = item.id
            VoiceManager.shared.stop()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
                guard let self else { return }
                self.currentStepIndex += 1
                if self.currentStepIndex >= self.level.steps.count {
                    let msg = FeedbackMessages.pick(from: FeedbackMessages.completion,
                                                   avoiding: self.lastCompletionMessage)
                    self.lastCompletionMessage = msg
                    self.successMessage  = msg
                    self.feedbackMessage = nil
                    self.feedbackKind    = .neutral
                    self.phase           = .success
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { [weak self] in
                        self?.correctItemID = nil
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) { [weak self] in
                        guard let self, self.phase == .success else { return }
                        self.advanceLevel()
                    }
                } else {
                    self.correctItemID = nil
                    let msg = FeedbackMessages.pick(from: FeedbackMessages.correct,
                                                   avoiding: self.lastCorrectMessage)
                    self.lastCorrectMessage = msg
                    self.feedbackKind    = .success
                    self.feedbackMessage = msg
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.45) { [weak self] in
                        guard let self, self.phase == .playing else { return }
                        self.feedbackMessage = nil
                    }
                    self.scheduleHints()
                }
            }
        } else {
            let msg = FeedbackMessages.pick(from: FeedbackMessages.error,
                                            avoiding: lastErrorMessage)
            lastErrorMessage = msg
            feedbackKind     = .neutral
            feedbackMessage  = msg
            phase            = .error
            errorItemID      = item.id
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [weak self] in
                guard let self else { return }
                self.errorItemID    = nil
                self.feedbackMessage = nil
                self.phase          = .playing
                self.scheduleHints()
            }
        }
    }

    func advanceLevel() {
        levelsCompleted += 1
        if isLastLevel {
            currentSetIndex = nextEnabledSetIndex(after: currentSetIndex)
            themeLevels     = LevelData.levels(for: currentSet)
            currentLevelIndex = 0
            recordVisit()
            let themeName = currentSet.theme.displayName
            restart()
            feedbackKind    = .neutral
            feedbackMessage = themeName
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
                guard let self, self.feedbackMessage == themeName else { return }
                withAnimation(.easeOut(duration: 0.3)) { self.feedbackMessage = nil }
            }
        } else {
            currentLevelIndex += 1
            restart()
        }
    }

    func restart() {
        cancelHints()
        VoiceManager.shared.stop()
        correctItemID  = nil
        errorItemID    = nil
        feedbackMessage = nil
        feedbackKind    = .neutral
        successMessage  = nil
        currentStepIndex = 0
        phase           = .playing
        speakLevelInstruction()
    }

    // MARK: - Theme helpers

    private func firstEnabledSetIndex() -> Int {
        let enabled = SessionStore.shared.enabledThemes
        return ItemLibrary.allSets.indices.first {
            enabled.contains(ItemLibrary.allSets[$0].theme)
        } ?? 0
    }

    private func nextEnabledSetIndex(after current: Int) -> Int {
        let count   = ItemLibrary.allSets.count
        let enabled = SessionStore.shared.enabledThemes
        for offset in 1...count {
            let next = (current + offset) % count
            if enabled.contains(ItemLibrary.allSets[next].theme) { return next }
        }
        return current  // all disabled — stay (UI guards against this)
    }

    private func recordVisit() {
        let name = currentSet.theme.displayName
        if !visitedSetNames.contains(name) { visitedSetNames.append(name) }
    }

    // MARK: - Progressive Hints

    private func armHints(afterDelay delay: TimeInterval) {
        hintArmWork?.cancel()
        let work = DispatchWorkItem { [weak self] in
            guard let self, self.phase == .playing else { return }
            self.scheduleHints()
        }
        hintArmWork = work
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: work)
    }

    private func scheduleHints() {
        cancelHints()
        let w2 = DispatchWorkItem { [weak self] in
            guard let self, self.phase == .playing else { return }
            self.hintItemID = self.currentStep?.targetItemID
        }
        hintWork2 = w2
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0, execute: w2)

        let w3 = DispatchWorkItem { [weak self] in
            guard let self, self.phase == .playing else { return }
            self.speakStepInstruction()
        }
        hintWork3 = w3
        DispatchQueue.main.asyncAfter(deadline: .now() + 6.0, execute: w3)
    }

    private func cancelHints() {
        hintArmWork?.cancel(); hintArmWork = nil
        hintWork1?.cancel();   hintWork1 = nil
        hintWork2?.cancel();   hintWork2 = nil
        hintWork3?.cancel();   hintWork3 = nil
        hintItemID = nil
    }

    // MARK: - Bundled Audio

    private func speakLevelInstruction() {
        let fallback = instructionText(for: level)
        if let file = bundledStartFile(level: currentLevelIndex) {
            print("[Audio] level start — set: \(audioPrefix(for: currentSetIndex) ?? "nil"), file: \(file)")
            VoiceManager.shared.playBundled(file: file, fallbackText: fallback)
        } else {
            VoiceManager.shared.speak(fallback)
        }
        let audioDuration = VoiceManager.shared.currentAudioDuration
        let armDelay = (audioDuration > 0 ? audioDuration : 3.0) + 2.5
        armHints(afterDelay: armDelay)
    }

    private func speakStepInstruction() {
        let fallback = currentStep?.instruction ?? ""
        if let file = bundledStepFile(level: currentLevelIndex, step: currentStepIndex) {
            print("[Audio] step — set: \(audioPrefix(for: currentSetIndex) ?? "nil"), file: \(file)")
            VoiceManager.shared.playBundled(file: file, fallbackText: fallback)
        } else {
            VoiceManager.shared.speak(fallback)
        }
    }

    private func instructionText(for level: MissionLevel) -> String {
        let steps = level.steps.map { $0.instruction }
        guard let first = steps.first else { return "" }
        let rest = steps.dropFirst().map { ", then " + $0.lowercased() }
        return first + rest.joined()
    }

    private func audioPrefix(for setIndex: Int) -> String? {
        switch setIndex {
        case 0: return "shapes_a1"
        case 1: return "animals_b1"
        case 2: return "vehicles_c1"
        default: return nil
        }
    }

    private func bundledStartFile(level: Int) -> String? {
        guard let prefix = audioPrefix(for: currentSetIndex) else { return nil }
        return String(format: "%@_l%02d_start", prefix, level + 1)
    }

    private func bundledStepFile(level: Int, step: Int) -> String? {
        guard let prefix = audioPrefix(for: currentSetIndex) else { return nil }
        return String(format: "%@_l%02d_step%d", prefix, level + 1, step + 1)
    }
}
