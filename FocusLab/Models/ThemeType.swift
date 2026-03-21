import Foundation

/// Content theme that determines which item vocabulary is loaded.
/// Each theme supplies 4 items with consistent color roles:
///   slot 0 → blue  |  slot 1 → red  |  slot 2 → green  |  slot 3 → yellow
///
/// Add a new case here and a matching branch in ItemLibrary.catalogue(for:)
/// and Vocabulary.make(for:) in LevelData to introduce a new theme.
enum ThemeType: String, CaseIterable {
    case shapes
    case animals
    case vehicles

    var displayName: String { rawValue.capitalized }

    var next: ThemeType {
        let all = ThemeType.allCases
        let idx = all.firstIndex(of: self)!
        return all[(idx + 1) % all.count]
    }
}
