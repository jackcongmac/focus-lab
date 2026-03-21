import Foundation

/// Single source of truth for all content sets.
/// Each ContentSet holds exactly 4 items in slot order: blue · red · green · yellow
enum ItemLibrary {

    // MARK: - All Sets (ordered for rotation)

    static let allSets: [ContentSet] = [setA1, setB1, setC1]

    // MARK: - Set Definitions

    /// Shapes A1: circle · square · triangle · star
    private static let setA1 = ContentSet(
        id: "A1",
        theme: .shapes,
        items: [
            makeItem(type: .shape(.circle)),
            makeItem(type: .shape(.square)),
            makeItem(type: .shape(.triangle)),
            makeItem(type: .shape(.star))
        ]
    )

    /// Animals B1: bird · fish · rabbit · turtle  (per ThemeSystem.md §4.2)
    private static let setB1 = ContentSet(
        id: "B1",
        theme: .animals,
        items: [
            makeItem(type: .sfSymbol(name: "bird.fill",     displayName: "bird")),
            makeItem(type: .sfSymbol(name: "fish.fill",     displayName: "fish")),
            makeItem(type: .sfSymbol(name: "hare.fill",     displayName: "rabbit")),
            makeItem(type: .sfSymbol(name: "tortoise.fill", displayName: "turtle"))
        ]
    )

    /// Vehicles C1: car · bus · train · airplane
    private static let setC1 = ContentSet(
        id: "C1",
        theme: .vehicles,
        items: [
            makeItem(type: .sfSymbol(name: "car.fill",  displayName: "car")),
            makeItem(type: .sfSymbol(name: "bus.fill",  displayName: "bus")),
            makeItem(type: .sfSymbol(name: "tram.fill", displayName: "train")),
            makeItem(type: .sfSymbol(name: "airplane",  displayName: "airplane"))
        ]
    )

    // MARK: - Factory

    static func makeItem(type: ItemType) -> Item {
        Item(id: UUID(), type: type)
    }
}
