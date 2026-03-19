import SwiftUI

// MARK: - Shared Colors

private let colorBlue   = Color(red: 0.40, green: 0.65, blue: 0.90)
private let colorRed    = Color(red: 0.90, green: 0.50, blue: 0.45)
private let colorGreen  = Color(red: 0.45, green: 0.75, blue: 0.60)
private let colorYellow = Color(red: 0.95, green: 0.80, blue: 0.35)
// Muted: used in L3 to remove color as a cue (shape-only recognition)
private let colorMuted  = Color(red: 0.72, green: 0.72, blue: 0.75)

// MARK: - Level Catalogue

enum LevelData {

    /// All 10 levels in order. Each call to `levels` produces fresh UUIDs,
    /// which is fine — the array is accessed once at app start.
    static let levels: [MissionLevel] = [
        level1(), level2(), level3(), level4(), level5(),
        level6(), level7(), level8(), level9(), level10()
    ]
}

// MARK: - Level Builders

// L1 — perception: color + shape (1 step, all distinct)
private func level1() -> MissionLevel {
    let circle   = PlayItem(id: UUID(), shape: .circle,   color: colorBlue)
    let square   = PlayItem(id: UUID(), shape: .square,   color: colorRed)
    let triangle = PlayItem(id: UUID(), shape: .triangle, color: colorGreen)
    let star     = PlayItem(id: UUID(), shape: .star,     color: colorYellow)
    return MissionLevel(
        title: "Level 1",
        items: [circle, square, triangle, star],
        steps: [
            MissionStep(instruction: "Tap the blue circle", targetItemID: circle.id)
        ]
    )
}

// L2 — perception: color + shape (1 step, different target)
private func level2() -> MissionLevel {
    let circle   = PlayItem(id: UUID(), shape: .circle,   color: colorBlue)
    let square   = PlayItem(id: UUID(), shape: .square,   color: colorRed)
    let triangle = PlayItem(id: UUID(), shape: .triangle, color: colorGreen)
    let star     = PlayItem(id: UUID(), shape: .star,     color: colorYellow)
    return MissionLevel(
        title: "Level 2",
        items: [circle, square, triangle, star],
        steps: [
            MissionStep(instruction: "Tap the yellow star", targetItemID: star.id)
        ]
    )
}

// L3 — perception: shape only (1 step, all items same muted color)
private func level3() -> MissionLevel {
    let circle   = PlayItem(id: UUID(), shape: .circle,   color: colorMuted)
    let square   = PlayItem(id: UUID(), shape: .square,   color: colorMuted)
    let triangle = PlayItem(id: UUID(), shape: .triangle, color: colorMuted)
    let star     = PlayItem(id: UUID(), shape: .star,     color: colorMuted)
    return MissionLevel(
        title: "Level 3",
        items: [circle, square, triangle, star],
        steps: [
            MissionStep(instruction: "Tap the triangle", targetItemID: triangle.id)
        ]
    )
}

// L4 — perception: color only (1 step, all items same shape — circle)
private func level4() -> MissionLevel {
    let blueCircle   = PlayItem(id: UUID(), shape: .circle, color: colorBlue)
    let redCircle    = PlayItem(id: UUID(), shape: .circle, color: colorRed)
    let greenCircle  = PlayItem(id: UUID(), shape: .circle, color: colorGreen)
    let yellowCircle = PlayItem(id: UUID(), shape: .circle, color: colorYellow)
    return MissionLevel(
        title: "Level 4",
        items: [blueCircle, redCircle, greenCircle, yellowCircle],
        steps: [
            MissionStep(instruction: "Tap the yellow one", targetItemID: yellowCircle.id)
        ]
    )
}

// L5 — working memory: 2-step sequence (all distinct)
private func level5() -> MissionLevel {
    let circle   = PlayItem(id: UUID(), shape: .circle,   color: colorBlue)
    let square   = PlayItem(id: UUID(), shape: .square,   color: colorRed)
    let triangle = PlayItem(id: UUID(), shape: .triangle, color: colorGreen)
    let star     = PlayItem(id: UUID(), shape: .star,     color: colorYellow)
    return MissionLevel(
        title: "Level 5",
        items: [circle, square, triangle, star],
        steps: [
            MissionStep(instruction: "Tap the blue circle",  targetItemID: circle.id),
            MissionStep(instruction: "Tap the yellow star",  targetItemID: star.id)
        ]
    )
}

// L6 — working memory: 2-step sequence (all distinct, different targets)
private func level6() -> MissionLevel {
    let circle   = PlayItem(id: UUID(), shape: .circle,   color: colorBlue)
    let square   = PlayItem(id: UUID(), shape: .square,   color: colorRed)
    let triangle = PlayItem(id: UUID(), shape: .triangle, color: colorGreen)
    let star     = PlayItem(id: UUID(), shape: .star,     color: colorYellow)
    return MissionLevel(
        title: "Level 6",
        items: [circle, square, triangle, star],
        steps: [
            MissionStep(instruction: "Tap the green triangle", targetItemID: triangle.id),
            MissionStep(instruction: "Tap the red square",     targetItemID: square.id)
        ]
    )
}

// L7 — selective attention: color distractor (two blue items, filter by shape)
private func level7() -> MissionLevel {
    let circle   = PlayItem(id: UUID(), shape: .circle,   color: colorBlue)
    let square   = PlayItem(id: UUID(), shape: .square,   color: colorBlue)
    let triangle = PlayItem(id: UUID(), shape: .triangle, color: colorGreen)
    let star     = PlayItem(id: UUID(), shape: .star,     color: colorYellow)
    return MissionLevel(
        title: "Level 7",
        items: [circle, square, triangle, star],
        steps: [
            MissionStep(instruction: "Tap the blue circle", targetItemID: circle.id),
            MissionStep(instruction: "Tap the blue square", targetItemID: square.id)
        ]
    )
}

// L8 — selective attention: shape distractor (two circles, filter by color)
private func level8() -> MissionLevel {
    let redCircle  = PlayItem(id: UUID(), shape: .circle,   color: colorRed)
    let blueCircle = PlayItem(id: UUID(), shape: .circle,   color: colorBlue)
    let triangle   = PlayItem(id: UUID(), shape: .triangle, color: colorGreen)
    let star       = PlayItem(id: UUID(), shape: .star,     color: colorYellow)
    return MissionLevel(
        title: "Level 8",
        items: [redCircle, blueCircle, triangle, star],
        steps: [
            MissionStep(instruction: "Tap the red circle",  targetItemID: redCircle.id),
            MissionStep(instruction: "Tap the blue circle", targetItemID: blueCircle.id)
        ]
    )
}

// L9 — working memory: 3-step sequence (all distinct, shape-only instructions)
private func level9() -> MissionLevel {
    let circle   = PlayItem(id: UUID(), shape: .circle,   color: colorBlue)
    let square   = PlayItem(id: UUID(), shape: .square,   color: colorRed)
    let triangle = PlayItem(id: UUID(), shape: .triangle, color: colorGreen)
    let star     = PlayItem(id: UUID(), shape: .star,     color: colorYellow)
    return MissionLevel(
        title: "Level 9",
        items: [circle, square, triangle, star],
        steps: [
            MissionStep(instruction: "Tap the circle",   targetItemID: circle.id),
            MissionStep(instruction: "Tap the star",     targetItemID: star.id),
            MissionStep(instruction: "Tap the square",   targetItemID: square.id)
        ]
    )
}

// L10 — working memory + selective attention: 3-step sequence with mixed distractors
//        (two circles + two blue items — child must use both color and shape)
private func level10() -> MissionLevel {
    let blueCircle  = PlayItem(id: UUID(), shape: .circle,   color: colorBlue)
    let redCircle   = PlayItem(id: UUID(), shape: .circle,   color: colorRed)
    let blueSquare  = PlayItem(id: UUID(), shape: .square,   color: colorBlue)
    let triangle    = PlayItem(id: UUID(), shape: .triangle, color: colorGreen)
    return MissionLevel(
        title: "Level 10",
        items: [blueCircle, redCircle, blueSquare, triangle],
        steps: [
            MissionStep(instruction: "Tap the blue circle",  targetItemID: blueCircle.id),
            MissionStep(instruction: "Tap the red circle",   targetItemID: redCircle.id),
            MissionStep(instruction: "Tap the blue square",  targetItemID: blueSquare.id)
        ]
    )
}
