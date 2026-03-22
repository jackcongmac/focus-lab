import SwiftUI

@main
struct FocusLabApp: App {
    var body: some Scene {
        WindowGroup {
            AppShell()
                .environmentObject(SessionStore.shared)
        }
    }
}
