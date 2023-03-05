//
//  SetGame.swift
//  Set
//
//  Created by Dana Zou on 13/11/2022.
//  model

import Foundation

struct SetGame {
    private (set) var cards: Array<Card>
    var cardsInDeck: [Array<Card>.Index]
    var cardsInGame: [Array<Card>.Index]
    var discardedCards = [Array<Card>.Index]()
    
    var selectedCards: [Array<Card>.Index] = []
    var selectedCount = 0
    var selectedComb: [Int] = [0,0,0,0]
    
    init(cards: Array<Card>, cardsInDeck: [Int], cardsInGame: [Int]) {
        self.cards = cards
        self.cardsInDeck = cardsInDeck
        self.cardsInGame = cardsInGame
    }
    
    var isSet: Bool = false
    
    mutating func clearSelected() {
        /* Removes all indices from selectedCards and reset related status */
        for index in selectedCards {
            // deselect cards that are already selected
            cards[index].isSelected = false
            cards[index].isSet = nil
        }
        selectedComb = [0,0,0,0]
        isSet = false
        
        selectedCards = []
    }
    
    mutating func choose(_ card: Card){
        if let chosenIndex = cards.firstIndex(where: {$0.id == card.id}) { // chosenIndex is index of the chosen card in our Card deck -> unshuffled, 0..<81, id == index
                        
            // there are already 3 chosen cards & currently selected card wasn't part of the 3
            if selectedCards.count == 3 {
                if cards[chosenIndex].isSelected {
                    if isSet == true {
                        // do nothing
                    } else {
                        clearSelected()
                    }
                } else {
                    for index in selectedCards {
                        if isSet == true{
                            // move index from cardsInGame -> discardedCards
                            if let inGameID = cardsInGame.firstIndex(of: index) {
                                discardedCards.append(cardsInGame.remove(at: inGameID))
                            }
                        } else {
                            // do nothing
                        }
                    }
                    clearSelected()
                }
            }
            
            if selectedCards.count < 3 {
                if cards[chosenIndex].isSelected {
                    // deselect it
                    selectedComb = zip(selectedComb, cards[chosenIndex].combinations).map(-)
                    selectedCards.remove(at: selectedCards.firstIndex(of: chosenIndex)!)
                    cards[chosenIndex].isSelected.toggle()
                } else {
                    // select it and check for set
                    cards[chosenIndex].isSelected = true
                    
                    selectedComb = zip(selectedComb, cards[chosenIndex].combinations).map(+)
                    selectedCards.append(chosenIndex)
                    
                    
                    if selectedCards.count == 3 {
//                        setLoop: for index in selectedComb {
//                                switch index {
//                                case 0, 3, 6:
//                                    isSet = true
//                                default:
//                                    isSet = false
//                                    break setLoop
//                                }
//                            }
                        isSet = true
                        
                        for index in selectedCards {
                            cards[index].isSet = isSet
                        }
                    }
                }
            }
        }
    }
    
    mutating func dealMoreCards() {
        if isSet {
            for index in selectedCards {
                cards[index].isSelected = false
                
                discardedCards.append(cardsInGame[cardsInGame.firstIndex(of: index)!])
                cardsInGame[cardsInGame.firstIndex(of: index)!] = cardsInDeck.popLast()!
                
                clearSelected()
            }
        } else {
            cardsInGame.append(contentsOf: cardsInDeck[0..<3])
            cardsInDeck.removeFirst(3)
        }
    }
    
}


//                    if cards[index].isSet == true {
//
//                        // remove index from cardsInGame -> discardedCards, replace it with something from cardsInDeck
//                        if let inGameID = cardsInGame.firstIndex(of: index) {
//                            discardedCards.append(cardsInGame.remove(at: inGameID))
//                        }
//
////                            if let newCard = cardsInDeck.popLast() {
////                                cardsInGame[inGameID] = newCard
////                            } else {
////                                cardsInGame.remove(at: inGameID)
////                            }
//
//                        cards[index].isDiscarded = true
//
//                    } else if cards[index].isSet == false {
//                        cards[index].isSet = nil
//                    }
           
//            if !cards[chosenIndex].isSelected {
//
//                cards[chosenIndex].isSelected = true
//
//                selectedComb = zip(selectedComb, cards[chosenIndex].combinations).map(+)
//                selectedCards.append(chosenIndex)
//
//
//                if selectedCards.count == 3 {
////                setLoop: for index in selectedComb {
////                        switch index {
////                        case 0, 3, 6:
////                            isSet = true
////                        default:
////
////                            isSet = false
////                            break setLoop
////                        }
////                    }
//                    isSet = true
//
//                    for index in selectedCards {
//                        cards[index].isSet = isSet
//                    }
//                }
//
//            } else if selectedCards.count < 3 {
//                selectedComb = zip(selectedComb, cards[chosenIndex].combinations).map(-)
//                selectedCards.remove(at: selectedCards.firstIndex(of: chosenIndex)!)
//                cards[chosenIndex].isSelected.toggle()
//            }
