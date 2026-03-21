import Foundation

/// A content-layer training item from the Item Library.
///
/// `Item` is a pure data definition — it does NOT contain gameplay logic.
/// Color is NOT stored here; it is assigned by slot position when LevelData
/// builds a Vocabulary (slot 0 → blue, 1 → red, 2 → green, 3 → yellow).
struct Item: Identifiable {
    let id: UUID
    let type: ItemType
}
