import SwiftUI
import Combine

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

    private var lastCorrectMessage:    String? = nil
    private var lastErrorMessage:      String? = nil
    private var lastCompletionMessage: String? = nil

    /// Visual hint — set to the target item ID when the player is idle > 4 s.
    @Published var hintItemID: UUID? = nil

    // Arm gate — fires after start audio + grace period; only then schedules the 3 hint timers.
    private var hintArmWork: DispatchWorkItem? = nil

    // Three progressive hint timers (all cancelled on any tap / step change).
    private var hintWork1: DispatchWorkItem? = nil   // 2 s – audio
    private var hintWork2: DispatchWorkItem? = nil   // 4 s – highlight
    private var hintWork3: DispatchWorkItem? = nil   // 6 s – audio again

    private var currentSetIndex: Int = 0
    private var currentSet: ContentSet { ItemLibrary.allSets[currentSetIndex] }
    private var themeLevels: [MissionLevel] = LevelData.levels(for: ItemLibrary.allSets[0])

    var level: MissionLevel { themeLevels[currentLevelIndex] }
    var isLastLevel: Bool { currentLevelIndex == themeLevels.count - 1 }
    var levelCount: Int { themeLevels.count }

    /// Instruction area text: success message during .success, step instruction otherwise.
    var displayInstruction: String? {
        successMessage ?? currentStep?.instruction
    }

    init() {
        speakLevelInstruction()   // armHints called inside
    }

    var currentStep: MissionStep? {
        guard currentStepIndex < level.steps.count else { return nil }
        return level.steps[currentStepIndex]
    }

    // Prevent taps while a feedback animation is in flight
    private var isFeedbackActive: Bool { correctItemID != nil || errorItemID != nil }

    func itemTapped(_ item: PlayItem) {
        cancelHints()   // stop any pending hint the moment the user acts
        guard phase == .playing, !isFeedbackActive, let step = currentStep else { return }

        if item.id == step.targetItemID {
            correctItemID = item.id
            VoiceManager.shared.stop()   // silence current instruction immediately on tap
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
                guard let self else { return }
                self.currentStepIndex += 1
                if self.currentStepIndex >= self.level.steps.count {
                    // Level complete — keep tile highlighted, show success inline
                    let msg = FeedbackMessages.pick(from: FeedbackMessages.completion,
                                                   avoiding: self.lastCompletionMessage)
                    self.lastCompletionMessage = msg
                    self.successMessage = msg
                    self.feedbackMessage = nil
                    self.feedbackKind = .neutral
                    self.phase = .success
                    // Hold tile highlight for 0.6 s then clear
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { [weak self] in
                        self?.correctItemID = nil
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) { [weak self] in
                        guard let self, self.phase == .success else { return }
                        self.advanceLevel()
                    }
                } else {
                    // Mid-level correct step — clear highlight, show brief feedback,
                    // then schedule a hint after 2 s of idle (Memory Mode: no auto-play).
                    self.correctItemID = nil
                    let msg = FeedbackMessages.pick(from: FeedbackMessages.correct,
                                                   avoiding: self.lastCorrectMessage)
                    self.lastCorrectMessage = msg
                    self.feedbackKind = .success
                    self.feedbackMessage = msg
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.45) { [weak self] in
                        guard let self, self.phase == .playing else { return }
                        self.feedbackMessage = nil
                    }
                    self.scheduleHints()
                }
            }
        } else {
            // Spec 4.3 – red flash, message, reset after 0.8 s
            let msg = FeedbackMessages.pick(from: FeedbackMessages.error,
                                            avoiding: lastErrorMessage)
            lastErrorMessage = msg
            feedbackKind = .neutral
            feedbackMessage  = msg
            phase = .error
            errorItemID = item.id
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [weak self] in
                guard let self else { return }
                self.errorItemID = nil
                self.feedbackMessage = nil
                self.phase = .playing
                self.scheduleHints()   // hints target currentStepIndex (unchanged)
            }
        }
    }

    func advanceLevel() {
        if isLastLevel {
            // Completed all levels — rotate to the next content set
            currentSetIndex   = (currentSetIndex + 1) % ItemLibrary.allSets.count
            themeLevels       = LevelData.levels(for: currentSet)
            currentLevelIndex = 0
            let themeName = currentSet.theme.displayName
            restart()
            // Brief theme name ("Animals", "Vehicles", "Shapes") in feedback area
            feedbackKind = .neutral
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
        correctItemID = nil
        errorItemID = nil
        feedbackMessage = nil
        feedbackKind = .neutral
        successMessage = nil
        currentStepIndex = 0
        phase = .playing
        speakLevelInstruction()   // armHints called inside
    }

    // MARK: - Progressive Hints (Memory Mode)

    /// Arms the hint system after a delay (called only at level start).
    /// The arm work item is cancelled if the user taps before it fires.
    private func armHints(afterDelay delay: TimeInterval) {
        hintArmWork?.cancel()
        let work = DispatchWorkItem { [weak self] in
            guard let self, self.phase == .playing else { return }
            self.scheduleHints()
        }
        hintArmWork = work
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: work)
    }

    /// Schedules two escalating hints after the arm delay elapses.
    /// Hint 1 (4 s): subtle visual highlight on target tile only.
    /// Hint 2 (6 s): replay step audio; visual highlight stays until next tap.
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

    /// Plays setID_lXX_start.mp3 at level start; falls back to TTS if file is missing.
    /// After playback starts, arms the progressive hint timers to fire only after
    /// the audio finishes + a 2.5 s grace period (so the child has fair thinking time).
    private func speakLevelInstruction() {
        let fallback = instructionText(for: level)
        if let file = bundledStartFile(level: currentLevelIndex) {
            VoiceManager.shared.playBundled(file: file, fallbackText: fallback)
        } else {
            VoiceManager.shared.speak(fallback)
        }
        // Query duration immediately after playBundled so the player is initialised.
        // Falls back to 3 s estimate when TTS is used (AVAudioPlayer not loaded).
        let audioDuration = VoiceManager.shared.currentAudioDuration
        let armDelay = (audioDuration > 0 ? audioDuration : 3.0) + 2.5
        armHints(afterDelay: armDelay)
    }

    /// Plays setID_lXX_stepN.mp3 for the active step; falls back to TTS if file is missing.
    private func speakStepInstruction() {
        let fallback = currentStep?.instruction ?? ""
        if let file = bundledStepFile(level: currentLevelIndex, step: currentStepIndex) {
            VoiceManager.shared.playBundled(file: file, fallbackText: fallback)
        } else {
            VoiceManager.shared.speak(fallback)
        }
    }

    /// Derives the full spoken instruction from LevelData — single source of truth.
    /// Single step: "Tap the blue circle"
    /// Multi-step:  "Tap the blue circle, then tap the red circle"
    private func instructionText(for level: MissionLevel) -> String {
        let steps = level.steps.map { $0.instruction }
        guard let first = steps.first else { return "" }
        let rest = steps.dropFirst().map { ", then " + $0.lowercased() }
        return first + rest.joined()
    }

    /// Maps set index → globally unique audio file prefix.
    /// Returns nil for sets with no bundled audio yet.
    private func audioPrefix(for setIndex: Int) -> String? {
        switch setIndex {
        case 0: return "shapes_a1"
        case 1: return "animals_b1"
        case 2: return "vehicles_c1"
        default: return nil
        }
    }

    /// Returns e.g. "shapes_a1_l01_start" for the current set and level.
    private func bundledStartFile(level: Int) -> String? {
        guard let prefix = audioPrefix(for: currentSetIndex) else { return nil }
        return String(format: "%@_l%02d_start", prefix, level + 1)
    }

    /// Returns e.g. "shapes_a1_l05_step2" for the current set, level, and step.
    private func bundledStepFile(level: Int, step: Int) -> String? {
        guard let prefix = audioPrefix(for: currentSetIndex) else { return nil }
        return String(format: "%@_l%02d_step%d", prefix, level + 1, step + 1)
    }
}
