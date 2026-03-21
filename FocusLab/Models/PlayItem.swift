import SwiftUI

struct PlayItem: Identifiable {
    let id: UUID
    let content: ItemType      // what to render (shape, symbol, etc.)
    let itemColor: ItemColor   // semantic color — drives fill and instruction text

    var color: Color { itemColor.swiftUIColor }
}
