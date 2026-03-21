import SwiftUI

// MARK: - Level Catalogue

enum LevelData {

    /// Generates 10 levels for a content set. The cognitive structure is identical
    /// across all sets; only the item vocabulary changes.
    static func levels(for set: ContentSet) -> [MissionLevel] {
        let v = Vocabulary.make(for: set)
        return [
            level1(v), level2(v), level3(v), level4(v), level5(v),
            level6(v), level7(v), level8(v), level9(v), level10(v)
        ]
    }
}

// MARK: - Vocabulary

/// The 4 canonical PlayItems for a theme, used by all level builders.
/// Slot order: [0] blue  [1] red  [2] green  [3] yellow
private struct Vocabulary {
    let items: [PlayItem]

    subscript(i: Int) -> PlayItem { items[i] }

    /// Creates a variant of items[index] with a different color (fresh UUID).
    func variant(_ index: Int, color: ItemColor) -> PlayItem {
        PlayItem(id: UUID(), content: items[index].content, itemColor: color)
    }

    /// Slot-to-color mapping: position 0 → blue, 1 → red, 2 → green, 3 → yellow.
    /// Color is NOT stored on Item — it is assigned here by slot index.
    private static let slotColors: [ItemColor] = [.blue, .red, .green, .yellow]

    static func make(for set: ContentSet) -> Vocabulary {
        let items = set.items.enumerated().map { index, item in
            PlayItem(id: item.id, content: item.type, itemColor: Self.slotColors[index])
        }
        return Vocabulary(items: items)
    }
}

// MARK: - PlayItem instruction helpers

private extension PlayItem {
    /// "blue circle" / "blue rabbit" / "blue car"
    var colorAndType: String { "\(itemColor.displayName) \(content.displayName)" }
    /// "circle" / "rabbit" / "car"  (for type-only levels)
    var typeName: String { content.displayName }
}

// MARK: - Level Builders
//
// Each builder encodes a cognitive template. All 10 builders are
// theme-agnostic — they compose from the Vocabulary and derive
// instruction text automatically.
//
// Slot conventions used throughout:
//   v[0] = blue item    v[1] = red item
//   v[2] = green item   v[3] = yellow item

// L1 — perception: color + shape (1 step, tap the blue item)
private func level1(_ v: Vocabulary) -> MissionLevel {
    MissionLevel(
        title: "Level 1",
        items: [v[0], v[1], v[2], v[3]],
        steps: [
            MissionStep(instruction: "Tap the \(v[0].colorAndType)", targetItemID: v[0].id)
        ]
    )
}

// L2 — perception: color + shape (1 step, tap the yellow item)
private func level2(_ v: Vocabulary) -> MissionLevel {
    MissionLevel(
        title: "Level 2",
        items: [v[0], v[1], v[2], v[3]],
        steps: [
            MissionStep(instruction: "Tap the \(v[3].colorAndType)", targetItemID: v[3].id)
        ]
    )
}

// L3 — perception: type only (all muted — color removed as a cue)
private func level3(_ v: Vocabulary) -> MissionLevel {
    let m0 = v.variant(0, color: .muted)
    let m1 = v.variant(1, color: .muted)
    let m2 = v.variant(2, color: .muted)
    let m3 = v.variant(3, color: .muted)
    return MissionLevel(
        title: "Level 3",
        items: [m0, m1, m2, m3],
        steps: [
            MissionStep(instruction: "Tap the \(v[2].typeName)", targetItemID: m2.id)
        ]
    )
}

// L4 — perception: color only (all same type, 4 colors)
private func level4(_ v: Vocabulary) -> MissionLevel {
    let b = v.variant(0, color: .blue)
    let r = v.variant(0, color: .red)
    let g = v.variant(0, color: .green)
    let y = v.variant(0, color: .yellow)
    return MissionLevel(
        title: "Level 4",
        items: [b, r, g, y],
        steps: [
            MissionStep(instruction: "Tap the yellow one", targetItemID: y.id)
        ]
    )
}

// L5 — working memory: 2-step sequence (tap blue, then yellow)
private func level5(_ v: Vocabulary) -> MissionLevel {
    MissionLevel(
        title: "Level 5",
        items: [v[0], v[1], v[2], v[3]],
        steps: [
            MissionStep(instruction: "Tap the \(v[0].colorAndType)", targetItemID: v[0].id),
            MissionStep(instruction: "Tap the \(v[3].colorAndType)", targetItemID: v[3].id)
        ]
    )
}

// L6 — working memory: 2-step sequence (tap green, then red)
private func level6(_ v: Vocabulary) -> MissionLevel {
    MissionLevel(
        title: "Level 6",
        items: [v[0], v[1], v[2], v[3]],
        steps: [
            MissionStep(instruction: "Tap the \(v[2].colorAndType)", targetItemID: v[2].id),
            MissionStep(instruction: "Tap the \(v[1].colorAndType)", targetItemID: v[1].id)
        ]
    )
}

// L7 — selective attention: color distractor
//      v[0] and a v[1]-variant share v[0]'s color — child must use type to distinguish
private func level7(_ v: Vocabulary) -> MissionLevel {
    let blueV1 = v.variant(1, color: v[0].itemColor)
    return MissionLevel(
        title: "Level 7",
        items: [v[0], blueV1, v[2], v[3]],
        steps: [
            MissionStep(instruction: "Tap the \(v[0].colorAndType)",    targetItemID: v[0].id),
            MissionStep(instruction: "Tap the \(blueV1.colorAndType)",  targetItemID: blueV1.id)
        ]
    )
}

// L8 — selective attention: type distractor
//      two items share v[0]'s type with different colors — child must use color to distinguish
private func level8(_ v: Vocabulary) -> MissionLevel {
    let redV0 = v.variant(0, color: .red)
    return MissionLevel(
        title: "Level 8",
        items: [v[0], redV0, v[2], v[3]],
        steps: [
            MissionStep(instruction: "Tap the \(v[0].colorAndType)",  targetItemID: v[0].id),
            MissionStep(instruction: "Tap the \(redV0.colorAndType)", targetItemID: redV0.id)
        ]
    )
}

// L9 — working memory: 3-step sequence using type-only instructions
private func level9(_ v: Vocabulary) -> MissionLevel {
    MissionLevel(
        title: "Level 9",
        items: [v[0], v[1], v[2], v[3]],
        steps: [
            MissionStep(instruction: "Tap the \(v[0].typeName)", targetItemID: v[0].id),
            MissionStep(instruction: "Tap the \(v[3].typeName)", targetItemID: v[3].id),
            MissionStep(instruction: "Tap the \(v[1].typeName)", targetItemID: v[1].id)
        ]
    )
}

// L10 — working memory + selective attention: 3-step mixed distractor
//       two v[0]-type items + two v[0]-color items — child must use both cues
private func level10(_ v: Vocabulary) -> MissionLevel {
    let redV0  = v.variant(0, color: .red)
    let blueV1 = v.variant(1, color: v[0].itemColor)
    return MissionLevel(
        title: "Level 10",
        items: [v[0], redV0, blueV1, v[2]],
        steps: [
            MissionStep(instruction: "Tap the \(v[0].colorAndType)",   targetItemID: v[0].id),
            MissionStep(instruction: "Tap the \(redV0.colorAndType)",  targetItemID: redV0.id),
            MissionStep(instruction: "Tap the \(blueV1.colorAndType)", targetItemID: blueV1.id)
        ]
    )
}
