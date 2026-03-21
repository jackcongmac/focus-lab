import SwiftUI

struct GameView: View {
    @StateObject private var vm = GameViewModel()
    @AppStorage(VoiceManager.enabledKey) private var voiceEnabled = true

    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                ZStack(alignment: .trailing) {
                    Text("Focus Lab")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(Color.indigo.opacity(0.85))
                        .frame(maxWidth: .infinity)

                    Button {
                        voiceEnabled.toggle()
                        if !voiceEnabled { VoiceManager.shared.stop() }
                    } label: {
                        Image(systemName: voiceEnabled ? "speaker.wave.2" : "speaker.slash")
                            .font(.body)
                            .foregroundStyle(Color.secondary.opacity(0.55))
                    }
                    .buttonStyle(.plain)
                }
                .padding(.top, 52)
                .padding(.bottom, 16)

                // Level progress dots
                HStack(spacing: 6) {
                    ForEach(0 ..< vm.levelCount, id: \.self) { i in
                        Circle()
                            .fill(i == vm.currentLevelIndex
                                  ? Color.indigo.opacity(0.75)
                                  : Color(.systemGray4))
                            .frame(width: i == vm.currentLevelIndex ? 8 : 6,
                                   height: i == vm.currentLevelIndex ? 8 : 6)
                    }
                }
                .padding(.bottom, 28)

                playingContent
                    .allowsHitTesting(vm.phase == .playing || vm.phase == .error)

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
            // Instruction area — shows step instruction or success message in place
            Text(vm.displayInstruction ?? " ")
                .font(.title3)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
                .foregroundColor(vm.phase == .success
                    ? Color.indigo.opacity(0.80)
                    : .primary.opacity(0.75))
                .opacity(vm.displayInstruction != nil ? 1 : 0)
                .scaleEffect(vm.phase == .success ? 1.06 : 1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: vm.phase == .success)

            // Progress dots
            HStack(spacing: 10) {
                ForEach(0 ..< vm.level.steps.count, id: \.self) { i in
                    Circle()
                        .fill(i < vm.currentStepIndex ? Color.indigo : Color(.systemGray4))
                        .frame(width: 9, height: 9)
                        .animation(.easeInOut(duration: 0.15), value: vm.currentStepIndex)
                }
            }

            // Inline feedback message (correct step + error)
            Text(vm.feedbackMessage ?? "")
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
                .opacity(vm.feedbackMessage != nil ? 1 : 0)
                .animation(.easeInOut(duration: 0.15), value: vm.feedbackMessage != nil)

            // Companion orb — reacts to correct taps and level success
            CalmOrbView(isActive: vm.correctItemID != nil, isSuccess: vm.phase == .success)

            // 2×2 tap grid — position-based identity keeps tile cards persistent across levels
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(Array(vm.level.items.enumerated()), id: \.offset) { _, item in
                    PlayItemButton(
                        item: item,
                        feedback: itemFeedback(for: item),
                        isHinted: vm.hintItemID == item.id
                    ) {
                        vm.itemTapped(item)
                    }
                }
            }
            .frame(maxWidth: 360)
        }
    }
}
