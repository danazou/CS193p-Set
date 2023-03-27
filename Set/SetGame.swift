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
    
    private var hintActive = false
    private var hintedSet = [Int]()
    
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
        /* Resets state of card */
        cards[index].state = .inactive
    }
    
    mutating func choose(_ card: Card){
        var chosenIndex = cards.firstIndex(where: {$0.id == card.id}) ?? 0 // chosenIndex is index of the chosen card in our Card deck
        
        if hintActive {
            hintedSet.forEach { index in
                resetStatus(of: index)
            }
            hintActive = false
        }
                        
        // there are already 3 chosen cards
        if selectedCards.count == 3 {
            // currently selected card is already selected
            if cards[chosenIndex].state == .selected {
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
            else if cards[chosenIndex].state != .selected {
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
            if cards[chosenIndex].state == .selected {
                // deselect it
                selectedComb = zip(selectedComb, cards[chosenIndex].combinations).map(-)
                selectedCards.remove(at: selectedCards.firstIndex(of: chosenIndex)!)
                cards[chosenIndex].state = .inactive
            } else {
                // select it and check for set
                cards[chosenIndex].state = .selected
                
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
                        switch isSet {
                        case true:
                            cards[index].state = .correctSet
                        case false:
                            cards[index].state = .incorrrectSet
                        }
                    }
                }
            }
        }
    }
    
    mutating func setPresent (in cardCount: Int) -> Bool {
        var setPresent = false
        var comb = [0,0,0,0]
        
        if cardCount != 0 {
            let count = min(cardCount, 20)
            
        cardLoop: for (i, card) in cards[0..<count - 2].enumerated() {
            comb = card.combinations
            
            // skip cards that are a Set
            if card.state == .correctSet {
                continue
            }
            // check 2nd card
            for j in stride(from: i+1, to: count - 1, by: 1) {
                let potentialCard = cards[j]
                comb = zip(comb, potentialCard.combinations).map(+)
                
                // check 3rd card
                for k in stride(from: j+1, to: count, by: 1) {
                    let potentialMatch = cards[k]
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
                        hintedSet = [i, j, k]
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
        return setPresent
    }
    
    mutating func dealMoreCards() {
        // penalise
        if setPresent(in: activeCards) {
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
    
    mutating func showHint() {
        if !hintActive {
            hintActive = setPresent(in: activeCards)
            for index in hintedSet {
                cards[index].state = .hint
            }
            score -= 5
        }
    }
}
