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
        return SetGame(cards: cards)
    }
    
    @Published private var model: SetGame = createSetGame()
    
    private var masterDeck: [Card] {
        model.cards
    }
    
    var cards: [Card] {
        
        var cards: [Card] = []
        cards.append(contentsOf: masterDeck[0..<model.activeCards])

        return cards
    }
    
    var deck: [Card] {
        
        var deck: [Card] = []
        deck.append(contentsOf:masterDeck[model.activeCards...])
        
        return deck
    }
    
    var discardedCards: [Card] {
        model.discardedCards
    }
    
    var isNewGame: Bool = true
    
    var score: Int {
        model.score
    }
    
    var setPresent: Bool {
        model.setPresent(in: model.activeCards).0
    }

    @ViewBuilder func symbol(_ shape: String, opacity: CGFloat, strokeWidth width: CGFloat) -> some View {
        switch shape {
        case "🟡 oval":
            Capsule().opacity(opacity)
                .background(in: Capsule())
            Capsule().strokeBorder(lineWidth: width)
        case "🟥 rectangle":
            Rectangle().opacity(opacity)
                .background(in: Rectangle())
            Rectangle().strokeBorder(lineWidth: width)
        case "🔷 diamond":
            Diamond().opacity(opacity)
                .background(in: Diamond())
            Diamond().stroke(lineWidth: width)
        default:
            RoundedRectangle(cornerRadius: 8)
        }
    }
    
    /*
     Shading is a func that takes string -> returns a fill
     Symbol has argument shading, that takes in string
     Within symbol, func shading that determines fill
     */
    
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
    
    func dealGame () {
        model.dealGame()
    }
}

/*
 Extra credit
 1. Draw the actual squiggle instead of using a rectangle.
 
 2. Draw the actual striped “shading” instead of using a semi-transparent color.
 
 3. Keep score somehow in your Set game. You can decide what sort of scoring would
 make the most sense.
 
 4. Give higher scores to players who choose matching Sets faster (i.e. incorporate a time
 component into your scoring system).
 
 5. Figure out how to penalize players who chose Deal 3 More Cards when a Set was
 actually available to be chosen.
 
 6. Add a “cheat” button to your UI.
 
 7. Support two players. No need to go overboard here. Maybe just a button for each
 user (one upside-down at the top of the screen maybe?) to claim that they see a Set on
 the board. Then that player gets a (fairly short) amount of time to actually choose the
 Set or the other person gets as much time as they want to try to find a Set (or maybe
 they get a longer, but not unlimited amount of time?). Maybe hitting “Deal 3 More
 Cards” by one user gives the other some medium amount of time to choose a Set
 without penalty? You will need to figure out how to use Timer to do these timelimited things.
 
 8. Can you think of a way to make your application work for color-blind people? If you
 tackle this Extra Credit, make it so that “color-blind mode” is on only if some Bool
 somewhere is set to true (and submit your application with it in the false state). In
 other words, you must still satisfy the Required Tasks and they specifically ask you to
 use 3 distinct colors. Some UI to change the value of this Bool is not required, but
 you can include it if you want.
 */
