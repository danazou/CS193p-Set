//
//  SetGame.swift
//  Set
//
//  Created by Dana Zou on 13/11/2022.
//  model

import Foundation

struct SetGame {
    private (set) var cards: Array<Card>
    var activeCards: Int = 0
    var discardedCards = [Card]()
    
    var selectedCards: [Array<Card>.Index] = []
    var selectedCount = 0
    var selectedComb: [Int] = [0,0,0,0]
    
    init(cards: Array<Card>) {
        self.cards = cards.shuffled()
    }
    
    var isSet: Bool = false
    
    mutating func clearSelected() {
        /* Removes all indices from selectedCards*/
        selectedComb = [0,0,0,0]
        isSet = false
        selectedCards = []
    }
    
    mutating func resetStatus(of index: Int) {
        /* Resets isSelected & isSet status of card */
        cards[index].isSelected = false
        cards[index].isSet = nil
    }
    
    mutating func choose(_ card: Card){
        var chosenIndex = cards.firstIndex(where: {$0.id == card.id}) ?? 0 // chosenIndex is index of the chosen card in our Card deck
                        
        // there are already 3 chosen cards
        if selectedCards.count == 3 {
            // currently selected card is already selected
            if cards[chosenIndex].isSelected {
                if isSet == true {
                    // do nothing
                } else {
                    for index in selectedCards {
                        resetStatus(of: index)
                    }
                    clearSelected()
                }
            }
            // currently selected card in't part of the 3 selected cards
            else if !cards[chosenIndex].isSelected {
                for index in selectedCards.sorted().reversed() {
                    if isSet == true {
                        // reset card status
                        resetStatus(of: index)
                        // move card from cards -> discardedCards
                        discardedCards.append(cards.remove(at: index))
                        activeCards -= 1
                    } else {
                        // reset card status
                        resetStatus(of: index)
                    }
                }
                clearSelected()
                chosenIndex = cards.firstIndex(where: {$0.id == card.id}) ?? 0
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
                setLoop: for index in selectedComb {
                        switch index {
                        case 0, 3, 6:
                            isSet = true
                        default:
                            isSet = false
                            break setLoop
                        }
                    }
//                    isSet = false
                    
                    for index in selectedCards {
                        cards[index].isSet = isSet
                    }
                }
            }
        }
    }
    
    mutating func dealMoreCards() {
        if isSet {
            for index in selectedCards {
                // reset card status
                resetStatus(of: index)
                // move card into discardPile
                discardedCards.append(cards.remove(at: index))
                // replace with new card
                let newCard = cards.remove(at: activeCards - 1)
                cards.insert(newCard, at: index)
            }
            clearSelected()
        } else {
            activeCards += 3
        }
    }
    
    mutating func dealGame() {
        activeCards += 12
    }
    
}
