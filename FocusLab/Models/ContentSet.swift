import Foundation

/// A named group of exactly 4 items used in one gameplay session.
///
/// Structure: Theme → Set → Items
///
/// Each set belongs to one Theme and follows the shared color mapping:
///   slot 0 → blue  |  slot 1 → red  |  slot 2 → green  |  slot 3 → yellow
///
/// Multiple sets per theme are supported (A1, A2…) for future content expansion.
struct ContentSet: Identifiable {
    let id: String          // e.g. "A1", "B1", "C1"
    let theme: ThemeType
    let items: [Item]       // always exactly 4, in slot order
}
