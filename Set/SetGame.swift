//
//  SetGame.swift
//  Set
//
//  Created by Dana Zou on 13/11/2022.
//  model

import Foundation

struct SetGame {
    private (set) var cards: Array<Card>
    private (set) var activeCards: Int = 0
    private (set) var discardedCards = [Card]()
    
    private var selectedCards: [Array<Card>.Index] = []
    private var selectedCount = 0
    private var selectedComb: [Int] = [0,0,0,0]
    
    private (set) var score: Int
    private var timeStart: Date
    
    init(cards: Array<Card>) {
        self.cards = cards.shuffled()
        score = 0
        timeStart = Date()
    }
    
    private var isSet: Bool = false
    
    private mutating func clearSelected() {
        /* Removes all indices from selectedCards*/
        selectedComb = [0,0,0,0]
        isSet = false
        selectedCards = []
    }
    
    private mutating func resetStatus(of index: Int) {
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
            // reset stopwatch
            timeStart = Date()
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
//                    isSet = true
                    
                    // keep score
                    let elapsedTime = abs(timeStart.timeIntervalSinceNow)
                    let timeBoost = max((10 - elapsedTime), 1)
                    
                    if isSet {
                        score += 1 * Int(timeBoost)
                    } else if !isSet {
                        score -= 1
                    }
                    
                    for index in selectedCards {
                        cards[index].isSet = isSet
                    }
                }
            }
        }
    }
    
    func setPresent (in cardCount: Int) -> (Bool, [Int]) {
        var setPresent = false
        var potentialSet = [Int]()
        var comb = [0,0,0,0]
        
        if cardCount != 0 {
            
            // need to rename count
            let count = min(cardCount, 20)
            
        cardLoop: for (i, card) in cards[0..<count - 2].enumerated() {
            potentialSet = [i]
            comb = card.combinations
            
            // skip cards that are a Set
            if card.isSet == true {
                continue
            }
            // check 2nd card
            for (j, potentialCard) in cards [i+1..<count - 1].enumerated() {
                
                // add comb
                comb = zip(comb, potentialCard.combinations).map(+)
                
                // check 3rd card
                for potentialMatch in cards [j + i..<count] {
                    
                    // add comb
                    comb = zip(comb, potentialMatch.combinations).map(+)
                    
                    // check for set
                    setLoop: for index in comb {
                        
                        switch index {
                        case 0, 3, 6:
                            setPresent = true
                        default:
                            setPresent = false
                            break setLoop
                        }
                    }
                    
                    if setPresent {
                        // set found
                        potentialSet.append(contentsOf: [j, j+1])
                        break cardLoop
                    } else {
                        // remove comb
                        comb = zip(comb, potentialMatch.combinations).map(-)
                    }
                }
                // no set found
                comb = card.combinations
            }
        }
        }
        return (setPresent, potentialSet)
    }
    
    mutating func dealMoreCards() {
        // penalise
        if setPresent(in: activeCards).0 {
            score -= 1
        }
        
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
        timeStart = Date()
    }
    
    mutating func dealGame() {
        activeCards += 12
        timeStart = Date()
    }
    
}
