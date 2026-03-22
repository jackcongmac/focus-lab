import Foundation

/// The app's primary navigation destinations.
/// Single source of truth for tab identifiers, icons, and labels.
/// Used by AppNavigationBar for both the iPhone bottom bar and the iPad sidebar.
enum AppTab: String, CaseIterable, Identifiable {
    case home
    case train
    case parent

    var id: String { rawValue }

    /// SF Symbol name — shared across bottom bar and sidebar.
    var icon: String {
        switch self {
        case .home:   return "house.fill"
        case .train:  return "brain"
        case .parent: return "person.circle"
        }
    }

    /// Text label shown in the iPad sidebar.
    var label: String {
        switch self {
        case .home:   return "Activities"
        case .train:  return "Train"
        case .parent: return "Parent Area"
        }
    }
}
