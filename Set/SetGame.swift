//
//  SetGame.swift
//  Set
//
//  Created by Dana Zou on 13/11/2022.
//  model

import Foundation

struct SetGame {
    var cards: Array<Card>
    var cardsInDeck: [Int]
    var cardsInGame: [Int]
    
    init(cards: Array<Card>, cardsInDeck: [Int], cardsInGame: [Int]) {
        self.cards = cards
        self.cardsInDeck = cardsInDeck
        self.cardsInGame = cardsInGame
    }
    
    var selectedCount = 0
    var selectedComb: [Int] = [0,0,0,0]
    var selectedCards: [Array<Card>.Index] = []
    var isSet: Bool = false
    
    mutating func choose(_ card: Card){
        
        if let chosenIndex = cards.firstIndex(where: {$0.id == card.id}) { // chosenIndex is index of the chosen card in our Card deck -> unshuffled, 0..<81, id == index
            
            // there are already 3 chosen cards
            if selectedCount == 3, !cards[chosenIndex].isSelected {
                for id in selectedCards {
                    cards[id].isSelected.toggle()
                    if cards[id].isSet == true {
                        // remove index from cardsInGame, replace it with something from cardsInDeck
                        
                        if let inGameID = cardsInGame.firstIndex(of: id) {
                            if let newCard = cardsInDeck.popLast() {
                                cardsInGame[inGameID] = newCard
                            } else {
                                cardsInGame.remove(at: inGameID)
                            }
                        }
//                        if !cardsInDeck.isEmpty {
//                            cardsInGame[cardsInGame.firstIndex(of: id)!] = cardsInDeck.popLast()! // need to test end game when cardsInDeck.isEmpty == true
//                        } else {
//                            cardsInGame.remove(at: cardsInGame.firstIndex(of: id)!)
//                        }
                    } else if cards[id].isSet == false {
                        cards[id].isSet = nil
                    }
                }
                
                selectedCount = 0
                selectedComb = [0,0,0,0]
                selectedCards = []
                isSet = false
            }
            
            // card user chose isn't currently selected
            if !cards[chosenIndex].isSelected {
                selectedCount += 1
                
                selectedComb = zip(selectedComb, cards[chosenIndex].combinations).map(+)
                selectedCards.append(chosenIndex)
                
                cards[chosenIndex].isSelected.toggle()
                
                if selectedCount == 3 {
                    print("3 cards chosen")
                    print (selectedComb)
                setLoop: for index in selectedComb {
                        switch index {
                        case 0, 3, 6:
                            isSet = true
                        default:
                            
                            isSet = false
                            break setLoop
                        }
                    }
                    
                    for index in selectedCards {
                        cards[index].isSet = isSet
//                        cards[index].isSelected.toggle()
                    }
                }
                
            } else if selectedCount < 3 {
                selectedComb = zip(selectedComb, cards[chosenIndex].combinations).map(-)
                selectedCards.remove(at: selectedCards.firstIndex(of: chosenIndex)!)
//                print (activeCardIndices)
                selectedCount -= 1
                cards[chosenIndex].isSelected.toggle()
            }
        }
    }

    
    mutating func dealMoreCards() {
        if isSet{
            for index in selectedCards {
                cardsInGame[cardsInGame.firstIndex(of: index)!] = cardsInDeck.popLast()! // need to test end game when cardsInDeck.isEmpty == true
            }
        } else {
            cardsInGame.append(contentsOf: cardsInDeck[0..<3])
            cardsInDeck.removeFirst(3)
        }
    }
    
}
