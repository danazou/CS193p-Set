//
//  ClassicalSetGame.swift
//  Set
//
//  Created by Dana Zou on 13/11/2022.
// viewModel

import SwiftUI

class ClassicalSetGame: ObservableObject {
        
    static let theme = Theme(colors: ["red", "teal", "purple"], shadings: [0.0, 0.3, 1.0], shapes: ["🟡 oval", "🔷 diamond", "🟥 rectangle"])
   
    static func createSetGame() -> SetGame {

        var cards: Array<Card> = []
        var cardIndex = 0
        for shape in 0...2 {
            for num in 0...2 {
                for color in 0...2 {
                    for shading in 0...2 {
                        let combination = [shape, num, color, shading]
                        cards.append(Card(numberOfShapes: num + 1, color: theme.colors[color], shading: theme.shadings[shading], shape: theme.shapes[shape], id: cardIndex, combinations: combination))
                        cardIndex += 1
                    }
                }
            }
        }
        var cardsInDeck = Array(0..<81)
            .shuffled()
        var cardsInGame: [Int] = []
        for _ in 0..<12 {
            cardsInGame.append(cardsInDeck.removeFirst())
        }
        
        return SetGame(cards: cards, cardsInDeck: cardsInDeck, cardsInGame: cardsInGame)
    }
    
    @Published private var model: SetGame = createSetGame()
    
    private var masterDeck: [Card] {
        model.cards
    }
            
    
    var cards: [Card] {
        
        var cards: [Card] = []
        cards.append(contentsOf: masterDeck[0..<model.activeCards])
//        for i in model.cardsInGame{
//            cards.append(modelCards.first(where: {$0.id == i})!)
//        }

        return cards
    }
    
    var deck: [Card] {
        
        var deck: [Card] = []
        deck.append(contentsOf:masterDeck[model.activeCards...])
//        for i in model.cardsInDeck {
//            deck.append(modelCards.first(where: {$0.id == i})!)
//        }
        
        return deck
    }
    
    var discardedCards: [Card] {
        model.discardedCards
//        var discardedCards: [Card] = []
//        for i in model.discardedCards {
//            discardedCards.append(modelCards.first(where: {$0.id == i})!)
//        }
//        return discardedCards
    }
    
    var isNewGame: Bool = true

    @ViewBuilder func symbol(_ shape: String, opacity: CGFloat, strokeWidth width: CGFloat) -> some View {
        switch shape {
        case "🟡 oval":
            Capsule().opacity(opacity).background(in: Capsule())
            Capsule().strokeBorder(lineWidth: width)
        case "🟥 rectangle":
            Rectangle().opacity(opacity).background(in: Rectangle())
            Rectangle().strokeBorder(lineWidth: width)
        case "🔷 diamond":
            Diamond().opacity(opacity).background(in: Diamond())
            Diamond().stroke(lineWidth: width)
        default:
            RoundedRectangle(cornerRadius: 8)
        }
    }
    
    func findColor(of color: String) -> Color {
        switch color {
        case "red": return Color.red
        case "orange": return Color.orange
        case "blue": return Color.blue
        case "green": return Color.green
        case "pink": return Color.pink
        case "yellow": return Color.yellow
        case "purple": return Color.purple
        case "mint": return Color.mint
        case "teal": return Color.teal
        case "indigo": return Color.indigo
        case "lime": return Color(red: 138/255, green: 229/255, blue: 118/255)
        default: return Color.gray
        }
    }

    
    // MARK: - Intent(s)
    
    func choose(_ card: Card){
        model.choose(card)
    }
    
    func dealMoreCards() {
        model.dealMoreCards()
    }
    
    func newGame() {
        model = ClassicalSetGame.createSetGame()
        isNewGame = true
    }
}

/*
 need to look into:
 - computed properties
 - publishing/observable objects
 
 current problem: how do I show a subset of my cards, show more card via button
 */

//var numsExclude = nums.remove(at: nums.firstIndex(of: num))

//func createCards() -> Array<Card> {
//        var shape = ""
//        var numOfShapes = 0
//        var color = ""
//        var shading = ""
//        var cards: Array<Card> = []
//
//        for shapeOption in shapes {
//            shape = shapeOption
//            for num in 1...3 {
//                numOfShapes = num
//                for colorOption in colors {
//                    color = colorOption
//                    for shadingOption in shadings {
//                        shading = shadingOption
//                        cards.append(Card(numberOfShapes: numOfShapes, color: color, shading: shading, shape: shape))
//                    }
//                }
//            }
//        }
//        return cards
//    }

/*
 array of cards
 
 need to create a set of 81 unique cards -> these don't change throughout the game. which cards are shown changes, but the total set of cards remains unchanged. Each card has 4 features: #ofshapes, shading, colour, shape.
 1. determine shape - 3
 2. determine # of shapes - 3
 3. determine colour - 3
 4. determine shading - 3
 
 keep track of which cards I've shown in the game -> hmmmmmm
    e.g. cards.shuffle(),

 var cardsinGame: Int
 
 dealtCards = model.cards[0..<cardsinGame]
 
 "3 more cards" -> VM, cardsinGame += 3
 */

//    func createClassicalSetGame() -> SetGame{
//        var cardContentIndex = [""]
//
//        func determineContentIndex (for cardNumber: Int) -> String {
//            var numberOfRepeats = 0
//            let contentOptions = ["0", "1", "2"]
//            var contentIndex = ""
//
//            if numberOfRepeats == 4 {
////                contentIndex = contentOptions[optionIndex]
//            }
//
//            else{
//                numberOfRepeats += 1
//                contentIndex = determineContentIndex(for: cardNumber) + contentIndex
//            }
//
//            return contentIndex
//        }
//
//        for cardNumber in 0..<81{
//            cardContentIndex.append(determineContentIndex(for: cardNumber))
//        }
//
//        // transform cardContentIndex into int. cardContentIndex[cardIndex].removeFirst()
//
//        return SetGame(createCardContent: <#T##(Int) -> Card.CardContent#>)
//    }
