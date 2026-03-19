import SwiftUI

struct GameView: View {
    @StateObject private var vm = GameViewModel()

    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                Text("Focus Lab")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(Color.indigo.opacity(0.85))
                    .frame(maxWidth: .infinity)
                    .padding(.top, 52)
                    .padding(.bottom, 36)

                Group {
                    switch vm.phase {
                    case .instructions:
                        InstructionsView(steps: vm.level.steps)
                            .transition(.opacity.combined(with: .scale(scale: 0.97)))

                    case .playing, .error:
                        playingContent
                            .transition(.opacity.combined(with: .scale(scale: 0.97)))

                    case .success:
                        SuccessView(onNext: vm.restart)
                            .transition(.opacity.combined(with: .scale(scale: 0.97)))
                    }
                }
                .animation(.easeInOut(duration: 0.35), value: vm.phase)

                Spacer()
            }
            .padding(.horizontal, 24)
        }
    }

    private func itemFeedback(for item: PlayItem) -> ItemFeedback {
        if vm.correctItemID == item.id { return .correct }
        if vm.errorItemID   == item.id { return .error }
        return .idle
    }

    @ViewBuilder
    private var playingContent: some View {
        VStack(spacing: 28) {
            // Current step prompt
            if let step = vm.currentStep {
                Text(step.instruction)
                    .font(.title3)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.primary.opacity(0.75))
                    .animation(.easeInOut, value: vm.currentStepIndex)
            }

            // Progress dots
            HStack(spacing: 10) {
                ForEach(0 ..< vm.level.steps.count, id: \.self) { i in
                    Circle()
                        .fill(i < vm.currentStepIndex ? Color.indigo : Color(.systemGray4))
                        .frame(width: 9, height: 9)
                        .animation(.spring(response: 0.3), value: vm.currentStepIndex)
                }
            }

            // "Let's try again" message (Spec 4.3)
            Text("Let's try again")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .opacity(vm.phase == .error ? 1 : 0)
                .animation(.easeInOut(duration: 0.15), value: vm.phase)

            // 2×2 tap grid
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(vm.level.items) { item in
                    PlayItemButton(
                        item: item,
                        feedback: itemFeedback(for: item)
                    ) {
                        vm.itemTapped(item)
                    }
                }
            }
            .frame(maxWidth: 360)
        }
    }
}
