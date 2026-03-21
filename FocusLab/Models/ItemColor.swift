import SwiftUI

/// Semantic training colors used across all themes.
/// Centralizes color values so they aren't duplicated across level builders.
enum ItemColor: String, CaseIterable {
    case blue
    case red
    case green
    case yellow
    case muted      // removes color as a recognition cue (used in shape-only levels)

    var swiftUIColor: Color {
        switch self {
        case .blue:   return Color(red: 0.40, green: 0.65, blue: 0.90)
        case .red:    return Color(red: 0.90, green: 0.50, blue: 0.45)
        case .green:  return Color(red: 0.45, green: 0.75, blue: 0.60)
        case .yellow: return Color(red: 0.95, green: 0.80, blue: 0.35)
        case .muted:  return Color(red: 0.72, green: 0.72, blue: 0.75)
        }
    }

    var displayName: String { rawValue }
}
