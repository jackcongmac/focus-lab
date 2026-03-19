import SwiftUI
import Combine

@MainActor
final class GameViewModel: ObservableObject {
    @Published var phase: GamePhase = .instructions
    @Published var currentStepIndex: Int = 0
    @Published var correctItemID: UUID? = nil
    @Published var errorItemID: UUID? = nil

    let level: MissionLevel

    init() {
        let circle   = PlayItem(id: UUID(), shape: .circle,   color: Color(red: 0.40, green: 0.65, blue: 0.90))
        let square   = PlayItem(id: UUID(), shape: .square,   color: Color(red: 0.90, green: 0.50, blue: 0.45))
        let triangle = PlayItem(id: UUID(), shape: .triangle, color: Color(red: 0.45, green: 0.75, blue: 0.60))
        let star     = PlayItem(id: UUID(), shape: .star,     color: Color(red: 0.95, green: 0.80, blue: 0.35))

        let steps: [MissionStep] = [
            MissionStep(instruction: "Tap the blue circle",     targetItemID: circle.id),
            MissionStep(instruction: "Now tap the yellow star", targetItemID: star.id)
        ]

        level = MissionLevel(
            title: "Mission 1",
            items: [circle, square, triangle, star],
            steps: steps
        )

        scheduleTransitionToPlaying()
    }

    var currentStep: MissionStep? {
        guard currentStepIndex < level.steps.count else { return nil }
        return level.steps[currentStepIndex]
    }

    // Prevent taps while a feedback animation is in flight
    private var isFeedbackActive: Bool { correctItemID != nil || errorItemID != nil }

    func itemTapped(_ item: PlayItem) {
        guard phase == .playing, !isFeedbackActive, let step = currentStep else { return }

        if item.id == step.targetItemID {
            // Spec 4.2 – show green highlight for 0.2 s, then advance
            correctItemID = item.id
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
                guard let self else { return }
                self.correctItemID = nil
                self.currentStepIndex += 1
                if self.currentStepIndex >= self.level.steps.count {
                    withAnimation(.easeInOut(duration: 0.35)) { self.phase = .success }
                }
            }
        } else {
            // Spec 4.3 – red flash, message, reset after 0.8 s
            phase = .error
            errorItemID = item.id
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [weak self] in
                guard let self else { return }
                self.errorItemID = nil
                self.currentStepIndex = 0
                self.phase = .playing
            }
        }
    }

    func restart() {
        correctItemID = nil
        errorItemID = nil
        currentStepIndex = 0
        phase = .instructions
        scheduleTransitionToPlaying()
    }

    private func scheduleTransitionToPlaying() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            guard let self, self.phase == .instructions else { return }
            withAnimation(.easeInOut(duration: 0.35)) { self.phase = .playing }
        }
    }
}
