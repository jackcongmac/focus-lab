import SwiftUI

/// Root navigation shell — single owner of tab state and game routing.
///
/// Three primary screens share the same navigation level:
///   .home   → HomeView
///   .train  → GameplayView (when a session is active) or HomeView
///   .parent → ParentView (full screen, not a modal)
///
/// AppNavigationBar is always visible on all three screens:
///   iPhone — frosted-glass bottom tab bar via safeAreaInset
///   iPad   — 256 pt left sidebar via HStack
struct AppShell: View {
    @StateObject private var vm = GameViewModel()

    @State private var selectedTab:  AppTab = .home
    @State private var isGameActive  = false
    @State private var showSummary   = false

    @Environment(\.horizontalSizeClass) private var hSizeClass

    var body: some View {
        Group {
            if hSizeClass == .regular {
                iPadShell
            } else {
                iPhoneShell
            }
        }
        .onChange(of: vm.sessionEnded) { _, ended in
            if ended { showSummary = true }
        }
        .fullScreenCover(isPresented: $showSummary) {
            if let record = vm.lastRecord {
                SessionSummaryView(record: record) {
                    showSummary  = false
                    selectedTab  = .train
                    isGameActive = true
                    vm.startSession()
                }
            }
        }
    }

    // MARK: - iPhone shell

    private var iPhoneShell: some View {
        primaryContent
            .safeAreaInset(edge: .bottom, spacing: 0) {
                AppNavigationBar(
                    selectedTab: selectedTab,
                    level: currentLevel,
                    onSelect: handleTabSelect
                )
            }
    }

    // MARK: - iPad shell

    private var iPadShell: some View {
        HStack(spacing: 0) {
            AppNavigationBar(
                selectedTab: selectedTab,
                level: currentLevel,
                onSelect: handleTabSelect
            )
            primaryContent
        }
        .background(Color.flBackground.ignoresSafeArea())
    }

    // MARK: - Content routing

    @ViewBuilder
    private var primaryContent: some View {
        switch selectedTab {
        case .home:
            HomeView(
                sessionState: vm.sessionState,
                onStart:   startGame,
                onResume:  resumeGame,
                onRestart: startGame
            )
        case .train:
            if isGameActive {
                GameplayView(vm: vm)
            } else {
                HomeView(
                    sessionState: vm.sessionState,
                    onStart:   startGame,
                    onResume:  resumeGame,
                    onRestart: startGame
                )
            }
        case .parent:
            ParentView(store: SessionStore.shared, lockedTheme: vm.activeTheme)
        }
    }

    // MARK: - Tab actions

    private func handleTabSelect(_ tab: AppTab) {
        switch tab {
        case .home:
            if vm.sessionState == .active { vm.pauseSession() }
            selectedTab  = .home
            isGameActive = false

        case .train:
            if vm.sessionState == .paused {
                resumeGame()
            } else {
                startGame()
            }

        case .parent:
            if vm.sessionState == .active { vm.pauseSession() }
            selectedTab  = .parent
            isGameActive = false
        }
    }

    // MARK: - Game lifecycle

    private func startGame() {
        selectedTab  = .train
        isGameActive = true
        vm.startSession()
    }

    private func resumeGame() {
        selectedTab  = .train
        isGameActive = true
        vm.resumeSession()
    }

    // MARK: - Helpers

    private var currentLevel: Int {
        let xp = SessionStore.shared.records.reduce(0) { $0 + $1.levelsCompleted * 25 }
        return max(1, xp / 100 + 1)
    }
}
