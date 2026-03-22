import SwiftUI

/// Shared navigation component.
///
/// Renders as a frosted-glass bottom tab bar on iPhone (compact width)
/// and as a 256 pt left sidebar on iPad (regular width).
///
/// Usage:
///   AppNavigationBar(selectedTab: selectedTab, level: level) { tab in
///       // handle selection
///   }
///
/// Both layouts derive their content from AppTab.allCases — no duplication.
struct AppNavigationBar: View {
    let selectedTab: AppTab
    let level: Int
    let onSelect: (AppTab) -> Void

    @Environment(\.horizontalSizeClass) private var hSizeClass

    var body: some View {
        if hSizeClass == .regular {
            sidebar
        } else {
            bottomBar
        }
    }

    // MARK: - Bottom bar (iPhone)

    private var bottomBar: some View {
        VStack(spacing: 0) {
            // Thin top edge — separates bar from content without floating
            Rectangle()
                .fill(Color.flDark.opacity(0.08))
                .frame(height: 0.5)

            HStack(spacing: 50) {
                ForEach(AppTab.allCases) { tab in
                    bottomTabButton(tab)
                }
            }
            .padding(.horizontal, 40)
            .frame(height: 60)
        }
        .background(.ultraThinMaterial)
        .safeAreaPadding(.bottom)
    }

    private func bottomTabButton(_ tab: AppTab) -> some View {
        let active = tab == selectedTab
        return Button { onSelect(tab) } label: {
            Image(systemName: tab.icon)
                .font(.system(size: active ? 20 : 22, weight: .medium))
                .foregroundStyle(active ? .white : Color.flSecondary.opacity(0.70))
                .frame(width: 24, height: 24)
                .padding(11)
                .background(
                    active ? Color.flNavActive : Color.clear,
                    in: Circle()
                )
        }
        .buttonStyle(.plain)
    }

    // MARK: - Sidebar (iPad)

    private var sidebar: some View {
        VStack(alignment: .leading, spacing: 32) {

            // Logo + level (sidebar-specific header chrome)
            VStack(alignment: .leading, spacing: 4) {
                Text("Focus Lab")
                    .font(.system(size: 24, weight: .black, design: .rounded))
                    .foregroundStyle(Color.flBrand)
                Text("LEVEL \(level) EXPLORER")
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                    .foregroundStyle(Color.flSecondary.opacity(0.70))
                    .tracking(1.2)
            }
            .padding(.horizontal, 8)

            // Tab links — same AppTab.allCases driving both layouts
            VStack(spacing: 8) {
                ForEach(AppTab.allCases) { tab in
                    sidebarTabButton(tab)
                }
            }

            Spacer()

            // Profile footer (decorative sidebar chrome, not a navigable tab)
            profileFooter
        }
        .padding(24)
        .frame(width: 256)
        .background(Color.flPanel)
        .ignoresSafeArea()
    }

    private func sidebarTabButton(_ tab: AppTab) -> some View {
        let active = tab == selectedTab
        return Button { onSelect(tab) } label: {
            HStack(spacing: 16) {
                Image(systemName: tab.icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(active ? Color.flBrand : Color.flDark.opacity(0.70))
                    .frame(width: 20, height: 20)
                Text(tab.label)
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundStyle(active ? Color.flBrand : Color.flDark.opacity(0.70))
                Spacer()
            }
            .padding(16)
            .background(
                active ? AnyShapeStyle(.white) : AnyShapeStyle(Color.clear),
                in: RoundedRectangle(cornerRadius: 12)
            )
            .shadow(
                color: active ? Color.black.opacity(0.05) : Color.clear,
                radius: 2, x: 0, y: 1
            )
        }
        .buttonStyle(.plain)
    }

    private var profileFooter: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(Color.flLight.opacity(0.30))
                .frame(width: 40, height: 40)
                .overlay(
                    Image(systemName: "person.fill")
                        .font(.system(size: 18))
                        .foregroundStyle(Color.flBrand)
                )
            VStack(alignment: .leading, spacing: 2) {
                Text("Learner")
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.flDark)
                Text("Focus Mode: ON")
                    .font(.system(size: 10, weight: .regular, design: .rounded))
                    .foregroundStyle(Color.flSecondary)
            }
            Spacer()
        }
        .padding(8)
        .background(.white, in: RoundedRectangle(cornerRadius: 12))
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}
