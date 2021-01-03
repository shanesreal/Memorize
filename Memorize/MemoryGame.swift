// MemoryGame.swift is the Model. Model–View–ViewModel (MVVM).
// The Model is UI independent, it contains all the data and logic.

// Foundation framework is required here we need basic types: String, Int, Double, Array, etc.
import Foundation

// struct is our goto data structure we use to encapsulate properties for MemoryGame.
struct MemoryGame<CardContent> where CardContent: Equatable {
    
    // Our game deals with cards, so we store properties in a generic Array (not String or Int).
     private(set) var cards: Array<Card>
    
    private var indexOfTheOneAndOnlyFaceUpCard: Int? {
        get { cards.indices.filter { cards[$0].isFaceUp }.only }
        set {
            for index in cards.indices {
                    cards[index].isFaceUp = index == newValue
            }
        }
    }
    
    // This "choose" function handles all of the card logic for our game.
    mutating func choose(card: Card) {
        // if cards.firstIndex returns =! nill then execute
        if let chosenIndex = cards.firstIndex(matching: card), !cards[chosenIndex].isFaceUp, !cards[chosenIndex].isMatched {
            if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard {
                if cards[chosenIndex].content == cards[potentialMatchIndex].content {
                    cards[chosenIndex].isMatched = true
                    cards[potentialMatchIndex].isMatched = true
                }
                cards[chosenIndex].isFaceUp = true
            } else {
                indexOfTheOneAndOnlyFaceUpCard = chosenIndex
            }
        }
    }
    
    // Initalize our game based on number of cards, also the card content type.
    init(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent) {
        // Empty array of cards
        cards = Array<Card>()
        for pairIndex in 0..<numberOfPairsOfCards {
            // here we are passing the function back and fourth
            let content = cardContentFactory(pairIndex)
            // append data into the empty array of cards
            cards.append(Card(content: content, id: pairIndex*2))
            cards.append(Card(content: content, id: pairIndex*2+1))
        }
        cards.shuffle()
    }
    
    // Card is a nested struct used to represent our card properties
    struct Card: Identifiable {
        var isFaceUp: Bool = false {
            didSet {
                if isFaceUp {
                    startUsingBonusTime()
                } else {
                    stopUsingBonusTime()
                }
            }
        }
        var isMatched: Bool = false {
            didSet {
                stopUsingBonusTime()
            }
        }
        // the card content could be either a String or Int so instead, we declare a generic type.
        var content: CardContent
        var id: Int
    
    
    // MARK: - Bonus Time
    // this could give matching bonus points
    // if the user matches the card
    // before a certain amount of time passes during which the card is face up
    // can be zero which means "no bonus available" for this card
    var bonusTimeLimit: TimeInterval = 6

    // how long this card has ever been face up
    private var faceUpTime: TimeInterval {
        if let lastFaceUpDate = self.lastFaceUpDate {
            return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
        } else {
            return pastFaceUpTime
        }
    }
    // the last time this card was turned face up (and is still face up)
    var lastFaceUpDate: Date?
    // the accumulated time this card has been face up in the past
    // (i.e. not including the current time it's been face up if it is currently so)
    var pastFaceUpTime: TimeInterval = 0

    // how much time left before the bonus opportunity runs out
    var bonusTimeRemaining: TimeInterval {
        max(0, bonusTimeLimit - faceUpTime)
    }
    // percentage of the bonus time remaining
    var bonusRemaining: Double {
        (bonusTimeLimit > 0 && bonusTimeRemaining > 0) ? bonusTimeRemaining/bonusTimeLimit : 0
    }
    // whether the card was matched during the bonus time period
    var hasEarnedBonus: Bool {
        isMatched && bonusTimeRemaining > 0
    }
    // whether we are currently face up, unmatched and have not yet used up the bonus window
    var isConsumingBonusTime: Bool {
        isFaceUp && !isMatched && bonusTimeRemaining > 0
    }
    // called when the card transitions to face up state
    private mutating func startUsingBonusTime() {
        if isConsumingBonusTime, lastFaceUpDate == nil {
            lastFaceUpDate = Date()
        }
    }
    // called when the card goes back face down (or gets matched)
    private mutating func stopUsingBonusTime() {
        pastFaceUpTime = faceUpTime
        self.lastFaceUpDate = nil
    }
}
}
