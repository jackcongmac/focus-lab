import SwiftUI

// MARK: - HomeView

/// Pure home-screen content view.
///
/// Has no knowledge of tab state or navigation — AppShell owns all of that.
/// Button UI is derived from `sessionState`:
///   .idle / .completed → Start
///   .paused            → Resume + Restart
///   .active            → (not reachable: AppShell shows gameplay instead)
struct HomeView: View {
    let sessionState: SessionState
    let onStart:   () -> Void
    let onResume:  () -> Void
    let onRestart: () -> Void

    @Environment(\.horizontalSizeClass) private var hSizeClass

    var body: some View {
        if hSizeClass == .regular {
            iPadMain
        } else {
            iPhoneHome
        }
    }

    // MARK: - iPhone layout

    private var iPhoneHome: some View {
        ZStack {
            Color.flBackground.ignoresSafeArea()

            VStack(spacing: 0) {
                iPhoneHeader
                    .padding(.horizontal, 32)
                    .padding(.top, 16)
                    .padding(.bottom, 16)

                Spacer(minLength: 0)

                iPhoneHero
                    .padding(.bottom, 48)

                iPhoneCTA
                    .padding(.horizontal, 32)
                    .frame(maxWidth: 384)

                Spacer(minLength: 0)
            }
        }
    }

    // MARK: iPhone — Header

    private var iPhoneHeader: some View {
        HStack {
            HStack(spacing: 8) {
                Image(systemName: "brain.head.profile")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(Color.flBrand)
                    .frame(width: 18, height: 21)

                Text("Focus Lab")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.flBrand)
            }

            Spacer()

            Text("Level \(currentLevel)")
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .foregroundStyle(Color.flDark)
                .tracking(-0.45)
        }
    }

    // MARK: iPhone — Hero

    private var iPhoneHero: some View {
        VStack(spacing: 0) {
            ZStack {
                Circle()
                    .fill(Color.flLight.opacity(0.20))
                    .frame(width: 197, height: 202)
                    .blur(radius: 32)

                RoundedRectangle(cornerRadius: 40)
                    .fill(.white)
                    .frame(width: 192, height: 192)
                    .shadow(color: Color.flDark.opacity(0.04), radius: 20, x: 0, y: 4)
                    .rotationEffect(.degrees(3))
                    .overlay(
                        Image(systemName: "brain.head.profile")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120, height: 120)
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [Color.flBrand, Color.flLight],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .opacity(0.9)
                            .rotationEffect(.degrees(-3))
                    )
            }
            .padding(.bottom, 32)

            Text("Focus Lab")
                .font(.system(size: 48, weight: .black, design: .rounded))
                .foregroundStyle(Color.flDark)
                .tracking(-1.2)
                .multilineTextAlignment(.center)
                .padding(.bottom, 12)

            Text("Daily practice for focus\nand following instructions")
                .font(.system(size: 18, weight: .regular, design: .rounded))
                .foregroundStyle(Color.flSecondary)
                .multilineTextAlignment(.center)
                .lineSpacing(5)
                .frame(maxWidth: 320)
        }
    }

    // MARK: iPhone — CTA

    private var iPhoneCTA: some View {
        VStack(spacing: 16) {
            if sessionState == .paused {
                iPhoneResumeButton
                iPhoneRestartButton
            } else {
                iPhoneStartButton
            }
            iPhoneStatsRow
        }
    }

    private var iPhoneStartButton: some View {
        Button(action: onStart) {
            Text("Start")
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundStyle(Color(red: 0.957, green: 0.945, blue: 1.0))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(
                    LinearGradient(
                        colors: [Color.flBrand, Color.flLight],
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    in: Capsule()
                )
                .shadow(color: Color.flBrand.opacity(0.20), radius: 16, x: 0, y: 8)
        }
        .buttonStyle(.plain)
    }

    private var iPhoneResumeButton: some View {
        Button(action: onResume) {
            Text("Resume")
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundStyle(Color(red: 0.957, green: 0.945, blue: 1.0))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(
                    LinearGradient(
                        colors: [Color.flBrand, Color.flLight],
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    in: Capsule()
                )
                .shadow(color: Color.flBrand.opacity(0.20), radius: 16, x: 0, y: 8)
        }
        .buttonStyle(.plain)
    }

    private var iPhoneRestartButton: some View {
        Button(action: onRestart) {
            Text("Restart")
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .foregroundStyle(Color.flSecondary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(Color.flPanel, in: Capsule())
        }
        .buttonStyle(.plain)
    }

    private var iPhoneStatsRow: some View {
        HStack(spacing: 0) {
            VStack(spacing: 4) {
                Image(systemName: "flame.fill")
                    .font(.system(size: 15))
                    .foregroundStyle(.orange)
                    .frame(width: 18, height: 16)
                Text("\(dayStreak)")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.flDark)
                Text("DAY STREAK")
                    .font(.system(size: 10, weight: .regular, design: .rounded))
                    .tracking(1)
                    .foregroundStyle(Color.flSecondary)
            }
            .frame(maxWidth: .infinity)

            Rectangle()
                .fill(Color(red: 0.671, green: 0.678, blue: 0.702).opacity(0.20))
                .frame(width: 1, height: 32)

            VStack(spacing: 4) {
                Text("\(focusXP)")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.flDark)
                Text("FOCUS XP")
                    .font(.system(size: 10, weight: .regular, design: .rounded))
                    .tracking(1)
                    .foregroundStyle(Color.flSecondary)
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.vertical, 20)
        .background(Color.flPanel, in: RoundedRectangle(cornerRadius: 32))
    }

    // MARK: - iPad layout

    /// On iPad the AppShell provides the sidebar via HStack.
    /// This view returns only the main content area.
    var iPadMain: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView {
                VStack(alignment: .leading, spacing: 48) {
                    iPadHeader
                    iPadHeroCard
                    iPadStatsRow
                    iPadChallenges
                }
                .padding(48)
            }
            .background(Color.flBackground)

        }
    }

    // MARK: iPad — Header

    private var iPadHeader: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 6) {
                Text("Welcome back!")
                    .font(.system(size: 30, weight: .black, design: .rounded))
                    .foregroundStyle(Color.flDark)
                    .tracking(-0.75)
                Text("Ready for today's brain exercises?")
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundStyle(Color.flSecondary)
            }
            Spacer()
            HStack(spacing: 16) {
                iPadIconButton(systemName: "trophy")
                iPadIconButton(systemName: "bell")
            }
        }
    }

    private func iPadIconButton(systemName: String) -> some View {
        Image(systemName: systemName)
            .font(.system(size: 16, weight: .medium))
            .foregroundStyle(Color.flDark.opacity(0.70))
            .frame(width: 48, height: 48)
            .background(.white, in: RoundedRectangle(cornerRadius: 12))
            .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
    }

    // MARK: iPad — Hero card

    private var iPadHeroCard: some View {
        ZStack {
            Circle()
                .fill(Color.white.opacity(0.10))
                .frame(width: 256, height: 256)
                .blur(radius: 32)
                .offset(x: -120, y: -80)

            Circle()
                .fill(Color(red: 0.643, green: 0.847, blue: 1.0).opacity(0.20))
                .frame(width: 192, height: 192)
                .blur(radius: 20)
                .offset(x: 160, y: 80)

            VStack(spacing: 20) {
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color.white.opacity(0.20))
                    .frame(width: 96, height: 96)
                    .overlay(
                        Image(systemName: "brain.head.profile")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 48)
                            .foregroundStyle(.white)
                    )

                Text("Today's Focus")
                    .font(.system(size: 48, weight: .black, design: .rounded))
                    .foregroundStyle(.white)
                    .tracking(-1.2)

                Text("Unlock your potential with \(SessionStore.shared.selectedDuration.rawValue) minutes of practice")
                    .font(.system(size: 18, weight: .medium, design: .rounded))
                    .foregroundStyle(Color.flLight.opacity(0.90))
                    .multilineTextAlignment(.center)

                Button(action: sessionState == .paused ? onResume : onStart) {
                    HStack(spacing: 12) {
                        Image(systemName: "play.fill")
                            .font(.system(size: 12, weight: .bold))
                        Text(sessionState == .paused ? "Resume Session" : "Start Session")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                    }
                    .foregroundStyle(Color.flBrand)
                    .padding(.vertical, 20)
                    .padding(.horizontal, 48)
                    .background(.white, in: Capsule())
                    .shadow(color: Color(red: 0.267, green: 0.247, blue: 0.686).opacity(0.30),
                            radius: 20, x: 0, y: 10)
                }
                .buttonStyle(.plain)

                if sessionState == .paused {
                    Button(action: onRestart) {
                        Text("Restart")
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                            .foregroundStyle(Color.white.opacity(0.70))
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(64)
        }
        .frame(maxWidth: .infinity)
        .background(
            LinearGradient(
                colors: [
                    Color(red: 0.314, green: 0.298, blue: 0.737),
                    Color(red: 0.267, green: 0.247, blue: 0.686)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 32))
        .shadow(color: Color.flBrand.opacity(0.20), radius: 30, x: 0, y: 15)
        .clipped()
    }

    // MARK: iPad — Stats row

    private var iPadStatsRow: some View {
        HStack(spacing: 32) {
            iPadStatCard {
                HStack(spacing: 24) {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(red: 0.969, green: 0.294, blue: 0.427).opacity(0.10))
                        .frame(width: 80, height: 80)
                        .overlay(
                            Image(systemName: "flame.fill")
                                .font(.system(size: 28))
                                .foregroundStyle(.orange)
                        )
                    VStack(alignment: .leading, spacing: 4) {
                        Text("DAY STREAK")
                            .font(.system(size: 14, weight: .bold, design: .rounded))
                            .foregroundStyle(Color.flSecondary)
                            .tracking(1.4)
                        Text("\(dayStreak) Days")
                            .font(.system(size: 36, weight: .black, design: .rounded))
                            .foregroundStyle(Color.flDark)
                    }
                    Spacer()
                }
            }

            iPadStatCard {
                HStack(spacing: 24) {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(red: 0.643, green: 0.847, blue: 1.0).opacity(0.20))
                        .frame(width: 80, height: 80)
                        .overlay(
                            Image(systemName: "bolt.fill")
                                .font(.system(size: 28))
                                .foregroundStyle(Color(red: 0.0, green: 0.38, blue: 0.55))
                        )
                    VStack(alignment: .leading, spacing: 4) {
                        Text("FOCUS XP")
                            .font(.system(size: 14, weight: .bold, design: .rounded))
                            .foregroundStyle(Color.flSecondary)
                            .tracking(1.4)
                        Text("\(focusXP)")
                            .font(.system(size: 36, weight: .black, design: .rounded))
                            .foregroundStyle(Color.flDark)
                        let pct = min(1.0, Double(focusXP) / 3000.0)
                        Text("Target: 3,000")
                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                            .foregroundStyle(Color.flSecondary)
                        GeometryReader { g in
                            ZStack(alignment: .leading) {
                                Capsule().fill(Color(red: 0.902, green: 0.910, blue: 0.937))
                                Capsule()
                                    .fill(Color(red: 0.0, green: 0.38, blue: 0.55))
                                    .frame(width: g.size.width * CGFloat(pct))
                            }
                        }
                        .frame(height: 12)
                    }
                    Spacer()
                }
            }
        }
    }

    @ViewBuilder
    private func iPadStatCard<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        content()
            .padding(33)
            .frame(maxWidth: .infinity, minHeight: 158)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(Color(red: 0.671, green: 0.678, blue: 0.702).opacity(0.05), lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
    }

    // MARK: iPad — Challenges

    private var iPadChallenges: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text("Upcoming Challenges")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundStyle(Color.flDark)

            HStack(spacing: 24) {
                challengeCard(
                    icon: "square.on.circle",
                    badge: "COGNITIVE",
                    badgeColor: Color(red: 0.0, green: 0.384, blue: 0.239),
                    badgeBg: Color(red: 0.651, green: 0.984, blue: 0.761).opacity(0.30),
                    borderColor: Color(red: 0.047, green: 0.412, blue: 0.239),
                    title: "Shapes Focus",
                    description: "Boost working memory through shape and color sequences.",
                    onTap: onStart
                )
                challengeCard(
                    icon: "waveform.path.ecg",
                    badge: "FOCUS",
                    badgeColor: Color(red: 0.078, green: 0.0, blue: 0.494),
                    badgeBg: Color.flLight.opacity(0.30),
                    borderColor: Color.flLight,
                    title: "Animal Match",
                    description: "Practice sustained attention by matching animal pairs.",
                    onTap: onStart
                )
                challengeCard(
                    icon: "car.fill",
                    badge: "CREATIVITY",
                    badgeColor: Color(red: 0.0, green: 0.298, blue: 0.435),
                    badgeBg: Color(red: 0.643, green: 0.847, blue: 1.0).opacity(0.30),
                    borderColor: Color(red: 0.0, green: 0.38, blue: 0.55),
                    title: "Vehicles",
                    description: "Exercise lateral thinking by identifying vehicles by color.",
                    onTap: onStart
                )
            }
        }
    }

    private func challengeCard(
        icon: String, badge: String, badgeColor: Color, badgeBg: Color,
        borderColor: Color, title: String, description: String, onTap: @escaping () -> Void
    ) -> some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(borderColor)
                    Spacer()
                    Text(badge)
                        .font(.system(size: 10, weight: .bold, design: .rounded))
                        .foregroundStyle(badgeColor)
                        .tracking(0.5)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(badgeBg, in: Capsule())
                }
                .padding(.bottom, 16)
                Text(title)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.flDark)
                    .padding(.bottom, 8)
                Text(description)
                    .font(.system(size: 12, weight: .regular, design: .rounded))
                    .foregroundStyle(Color.flSecondary)
                    .lineSpacing(4)
                    .fixedSize(horizontal: false, vertical: true)
                Spacer(minLength: 0)
            }
            .padding(24)
            .frame(maxWidth: .infinity, minHeight: 155, alignment: .topLeading)
            .background(Color.flPanel)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .inset(by: 0.5)
                    .stroke(borderColor, lineWidth: 4)
                    .mask(alignment: .leading) { Rectangle().frame(width: 4) }
            )
        }
        .buttonStyle(.plain)
    }

    // MARK: - Computed data

    private var dayStreak: Int {
        let records = SessionStore.shared.records
        guard !records.isEmpty else { return 0 }
        var streak = 0
        var check = Calendar.current.startOfDay(for: Date())
        for _ in 0..<365 {
            if records.contains(where: { Calendar.current.isDate($0.date, inSameDayAs: check) }) {
                streak += 1
                check = Calendar.current.date(byAdding: .day, value: -1, to: check)!
            } else { break }
        }
        return streak
    }

    private var focusXP: Int {
        SessionStore.shared.records.reduce(0) { $0 + $1.levelsCompleted * 25 }
    }

    private var currentLevel: Int {
        max(1, focusXP / 100 + 1)
    }
}

// MARK: - Shared FL color palette
// Internal (not private) so AppNavigationBar.swift can access these in the same module.

extension Color {
    static let flBackground = Color(red: 0.961, green: 0.965, blue: 0.988)
    static let flPanel      = Color(red: 0.937, green: 0.941, blue: 0.969)
    static let flBrand      = Color(red: 0.314, green: 0.298, blue: 0.737)
    static let flLight      = Color(red: 0.596, green: 0.584, blue: 1.0)
    static let flNavActive  = Color(red: 0.557, green: 0.545, blue: 0.996)
    static let flDark       = Color(red: 0.173, green: 0.184, blue: 0.200)
    static let flSecondary  = Color(red: 0.349, green: 0.357, blue: 0.380)
}
