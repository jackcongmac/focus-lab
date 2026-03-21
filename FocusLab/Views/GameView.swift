import SwiftUI

struct GameView: View {
    @StateObject private var vm = GameViewModel()
    @AppStorage(VoiceManager.enabledKey) private var voiceEnabled = true

    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {
        GeometryReader { geo in
            let m = LayoutMetrics(size: geo.size)

            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    // 1. Top bar — always tappable
                    topBar
                        .padding(.top, m.topPadding)
                        .padding(.bottom, m.topBarBottom)

                    // 2–6. Play zone — hit-testing gated by phase
                    VStack(spacing: 0) {
                        // 2. Step progress
                        stepProgress
                            .padding(.bottom, m.stepBottom)

                        // 3. Instruction — primary focal point
                        instructionArea
                            .padding(.bottom, m.instructionBottom)

                        // 4. Feedback — fixed height, never collapses
                        feedbackArea
                            .frame(height: m.feedbackHeight)
                            .padding(.bottom, m.feedbackBottom)

                        // 5. Tile grid — main action anchor
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
                        .frame(maxWidth: m.gridMaxWidth)
                        .padding(.bottom, m.gridBottom)

                        // 6. Level progress — bottom anchor
                        levelProgress
                    }
                    .allowsHitTesting(vm.phase == .playing || vm.phase == .error)

                    Spacer(minLength: 0)
                }
                .padding(.horizontal, 24)
            }
        }
    }

    // MARK: - Subviews

    private var topBar: some View {
        ZStack(alignment: .trailing) {
            Text("Focus Lab")
                .font(.system(size: 24, weight: .bold, design: .rounded))
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
    }

    /// Dot step indicator — lighter and simpler than level progress dots
    private var stepProgress: some View {
        HStack(spacing: 6) {
            ForEach(0 ..< vm.level.steps.count, id: \.self) { i in
                Circle()
                    .fill(
                        i < vm.currentStepIndex
                            ? Color.indigo.opacity(0.45)
                            : i == vm.currentStepIndex
                                ? Color.indigo.opacity(0.22)
                                : Color(.systemGray5)
                    )
                    .frame(width: 6, height: 6)
                    .animation(.easeInOut(duration: 0.2), value: vm.currentStepIndex)
            }
        }
    }

    private var instructionArea: some View {
        Text(vm.displayInstruction ?? " ")
            .font(.title2)
            .fontWeight(.semibold)
            .multilineTextAlignment(.center)
            .foregroundStyle(
                vm.phase == .success
                    ? Color(red: 0.22, green: 0.58, blue: 0.38).opacity(0.90)
                    : Color.primary.opacity(0.80)
            )
            .opacity(vm.displayInstruction != nil ? 1 : 0)
            .scaleEffect(vm.phase == .success ? 1.05 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: vm.phase == .success)
            .fixedSize(horizontal: false, vertical: true)
    }

    /// Fixed-height container prevents layout shifts when message appears / disappears
    private var feedbackArea: some View {
        let feedbackColor: Color = vm.feedbackKind == .success
            ? Color(red: 0.22, green: 0.58, blue: 0.38).opacity(0.90)
            : .secondary
        return Text(vm.feedbackMessage ?? "")
            .font(.subheadline)
            .fontWeight(.medium)
            .foregroundStyle(feedbackColor)
            .opacity(vm.feedbackMessage != nil ? 1 : 0)
            .animation(.easeInOut(duration: 0.15), value: vm.feedbackMessage != nil)
    }

    /// Capsule-row level indicator — visually distinct from step dots.
    /// completed = medium indigo bar · current = wide indigo pill · future = short grey bar
    private var levelProgress: some View {
        HStack(spacing: 5) {
            ForEach(0 ..< vm.levelCount, id: \.self) { i in
                Capsule()
                    .fill(levelSegmentColor(i))
                    .frame(width: levelSegmentWidth(i), height: 4)
                    .animation(.spring(response: 0.35, dampingFraction: 0.75),
                               value: vm.currentLevelIndex)
            }
        }
        .padding(.top, 14)
    }

    private func levelSegmentWidth(_ i: Int) -> CGFloat {
        if i == vm.currentLevelIndex { return 22 }
        if i < vm.currentLevelIndex  { return 10 }
        return 6
    }

    private func levelSegmentColor(_ i: Int) -> Color {
        if i == vm.currentLevelIndex { return Color.indigo.opacity(0.70) }
        if i < vm.currentLevelIndex  { return Color.indigo.opacity(0.28) }
        return Color(.systemGray5)
    }

    // MARK: - Helpers

    private func itemFeedback(for item: PlayItem) -> ItemFeedback {
        if vm.correctItemID == item.id { return .correct }
        if vm.errorItemID   == item.id { return .error }
        return .idle
    }
}

// MARK: - Responsive metrics

private struct LayoutMetrics {
    let topPadding: CGFloat
    let topBarBottom: CGFloat
    let stepBottom: CGFloat
    let instructionBottom: CGFloat
    let feedbackHeight: CGFloat
    let feedbackBottom: CGFloat
    let gridBottom: CGFloat
    let gridMaxWidth: CGFloat

    init(size: CGSize) {
        let isIPad = size.width >= 768

        topPadding        = isIPad ? 60  : 52
        topBarBottom      = isIPad ? 32  : 24   // ↑ pushes play zone down from title
        stepBottom        = isIPad ? 20  : 14   // ↑ +4pt loosened
        instructionBottom = isIPad ? 24  : 18   // ↑ +4pt loosened
        feedbackHeight    = 22
        feedbackBottom    = isIPad ? 28  : 20   // ↑ +4pt loosened
        gridBottom        = isIPad ? 32  : 22   // ↑ +4pt loosened
        gridMaxWidth      = isIPad ? 480 : 360
    }
}
