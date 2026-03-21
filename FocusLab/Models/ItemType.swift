/// The category of a displayable training item.
///
/// `.shape` covers all geometric shapes (Set A and B).
/// `.sfSymbol` is the stub for symbol-based themes (animals, vehicles) — replace
///  with asset-backed cases when real artwork is available.
enum ItemType: Equatable {
    case shape(ItemShape)
    case sfSymbol(name: String, displayName: String)
    case asset(name: String, displayName: String)   // bundled image asset (template rendering)

    var displayName: String {
        switch self {
        case .shape(let s):          return s.displayName
        case .sfSymbol(_, let name): return name
        case .asset(_, let name):    return name
        }
    }

    static func == (lhs: ItemType, rhs: ItemType) -> Bool {
        switch (lhs, rhs) {
        case (.shape(let a), .shape(let b)):              return a == b
        case (.sfSymbol(let a, _), .sfSymbol(let b, _)): return a == b
        case (.asset(let a, _), .asset(let b, _)):        return a == b
        default:                                          return false
        }
    }
}

// MARK: - ItemShape display + equality support

extension ItemShape {
    var displayName: String {
        switch self {
        case .circle:   return "circle"
        case .square:   return "square"
        case .triangle: return "triangle"
        case .star:     return "star"
        case .pentagon: return "pentagon"
        case .oval:     return "oval"
        case .diamond:  return "diamond"
        case .hexagon:  return "hexagon"
        }
    }
}
