// Grid.swift represents the grid UI layout

// SwiftUI framework is required here we need a View, Text, RoundedRectangle, etc.
import SwiftUI

// <Item> and <ItemView> we dont care about their values right now.
// We constrain our dont care "Item" and "ItemView" to "Identifiable" and "View" protocols so that we can use them in our body Views.
struct Grid<Item, ItemView>: View  where Item: Identifiable, ItemView: View {
    private var items: [Item]
    private var viewForItem: (Item) -> ItemView
    
    // @escaping = function will not be called, it will escape.
    init(_ items: [Item], viewForItem: @escaping (Item) -> ItemView) {
        self.items = items
        self.viewForItem = viewForItem
    }
    
    // we use "GeometryReader" to get the space required
    var body: some View {
        GeometryReader { geomerty in
            body(for: GridLayout(itemCount: items.count, in: geomerty.size))
        }
    }
    
    // we use "GridLayout" to divide it up:
    private func body(for layout: GridLayout) -> some View {
        ForEach(items) { item in
            body(for: item, in: layout)
        }
    }
    
    private func body(for item: Item, in layout: GridLayout) -> some View {
        let index = items.firstIndex(matching: item)!
        return viewForItem(item)
            // offer
            .frame(width: layout.itemSize.width, height: layout.itemSize.height)
            // position
            .position(layout.location(ofItemAt: index))
    }
}
