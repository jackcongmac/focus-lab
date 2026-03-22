import SwiftUI

/// Pure gameplay content view.
///
/// Receives an already-initialised GameViewModel from AppShell and renders
/// the active training session. Has no knowledge of navigation, tab state,
/// or modal presentation — those all live in AppShell.
struct GameplayView: View {
    @ObservedObject var vm: GameViewModel

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
                    topBar
                        .padding(.top, m.topPadding)
                        .padding(.bottom, m.topBarBottom)

                    VStack(spacing: 0) {
                        stepProgress
                            .padding(.bottom, m.stepBottom)

                        instructionArea
                            .padding(.bottom, m.instructionBottom)

                        feedbackArea
                            .frame(height: m.feedbackHeight)
                            .padding(.bottom, m.feedbackBottom)

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

                        levelProgress
                    }
                    .allowsHitTesting(!vm.isInStartBuffer && (vm.phase == .playing || vm.phase == .error))

                    Spacer(minLength: 0)
                }
                .padding(.horizontal, 24)
            }
        }
    }

    // MARK: - Subviews

    private var topBar: some View {
        ZStack {
            // Center: title + live countdown
            VStack(spacing: 2) {
                Text("Focus Lab")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.indigo.opacity(0.85))

                Text(vm.timeRemainingText)
                    .font(.system(size: 12, weight: .regular, design: .rounded))
                    .foregroundStyle(Color.secondary.opacity(0.65))
                    .monospacedDigit()
            }
            .frame(maxWidth: .infinity)

            // Trailing: voice toggle
            HStack {
                Spacer()
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
    }

    /// Dot step indicator — lighter and simpler than level progress capsules
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
        // ZStack keeps a stable layout frame while instructions swap in and out.
        // Each unique string gets its own identity via .id(), so every change —
        // first appearance, step advance, success message, "Session Started" fade —
        // triggers the same slide-up-and-fade transition.
        ZStack {
            // Invisible placeholder — keeps the ZStack height stable so the
            // grid doesn't jump when the instruction appears or disappears.
            Text(" ")
                .font(.title)
                .fontWeight(.semibold)
                .opacity(0)

            if let instruction = vm.displayInstruction {
                Text(instruction)
                    .font(.title)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(
                        vm.phase == .success
                            ? Color(red: 0.22, green: 0.58, blue: 0.38).opacity(0.90)
                            : Color.primary.opacity(0.80)
                    )
                    .fixedSize(horizontal: false, vertical: true)
                    .id(instruction)
                    .transition(.asymmetric(
                        insertion: .opacity.combined(with: .offset(CGSize(width: 0, height: 8))),
                        removal:   .opacity.combined(with: .offset(CGSize(width: 0, height: -4)))
                    ))
            }
        }
        .animation(.easeOut(duration: 0.3), value: vm.displayInstruction)
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

        topPadding        = isIPad ? 40  : 52
        topBarBottom      = isIPad ? 18  : 24
        stepBottom        = isIPad ? 12  : 14
        instructionBottom = isIPad ? 16  : 18
        feedbackHeight    = 22
        feedbackBottom    = isIPad ? 16  : 20
        gridBottom        = isIPad ? 18  : 22
        gridMaxWidth      = isIPad ? 480 : 360
    }
}
