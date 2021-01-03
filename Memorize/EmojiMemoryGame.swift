// EmojiMemoryGame.swift is the ViewModel. Model–View–ViewModel (MVVM).
// The ViewModel acts as a portal between the View and the Model.

// SwiftUI framework is used here to help translate and display View, Text, RoundedRectangle, etc.
import SwiftUI

// Our ViewModel uses a class (OOP) instead of a struct, since a class is easy to share with the View
// ObservableObject = broadcast that a change has been made.
class EmojiMemoryGame: ObservableObject {
    // @Published = when anything changes in our Model it calls objectWillChange.send() and publishes
    @Published private var model: MemoryGame<String> = EmojiMemoryGame.createMemoryGame()
    
    // private static function that creates an array of emojis and then returns them to Model.
    private static func createMemoryGame() -> MemoryGame<String> {
        let emojis = ["👻","🎃","🕷"]
        // this will return 2 pairs of cards based on how many emojis are in the emojis [array]
        return MemoryGame<String>(numberOfPairsOfCards: emojis.count) { pairIndex in
            return emojis[pairIndex]
        }
    }
        
    // MARK: - Access to the Model
    
    var cards: Array<MemoryGame<String>.Card> {
        model.cards
    }
    
    // MARK: - Intent(s)
    
    func Choose(card: MemoryGame<String>.Card) {
        model.choose(card: card)
    }
    
    func resetGame() {
        model = EmojiMemoryGame.createMemoryGame()
    }
}
