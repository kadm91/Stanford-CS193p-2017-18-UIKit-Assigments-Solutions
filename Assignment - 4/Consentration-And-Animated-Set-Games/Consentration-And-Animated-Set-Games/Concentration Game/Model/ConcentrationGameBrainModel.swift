//
//  ConcentrationGameBrainModel.swift
//  Consentration-And-Animated-Set-Games
//
//  Created by Kevin Martinez on 5/27/22.
//

import Foundation

typealias concentrationGameBrain = ConcentrationGameBrainModel

/**The mechanics for the concentration game*/
struct ConcentrationGameBrainModel {
    
    /**An array of cards to be use in the each game*/
    var cards = [Card]()
    /**The count of how many times the player have flip the cards*/
    private (set) var flipCount = 0
    /**The score of the player dependint if he/she made a match or a mistmatch*/
     private (set) var score = 0
    /**The index of the cartd the player selectd on screen*/
    private var indexOfSelectedCard: Int? {
        get{
            var selectedCardIndex: Int?
            for index in cards.indices {
                if cards[index].isfaceUP {
                    if selectedCardIndex == nil {
                        selectedCardIndex = index
                    } else {
                        return nil
                    }
                }
            }
            return selectedCardIndex
        }
        set {
            for index in cards.indices {
                cards[index].isfaceUP = (index == newValue)
            }
        }
    }
    
    //MARK: - Methods
    /**
     Evaluates if the two selected cards make a match or not
        - Parameters:
            - at: The selected card index
     */
    mutating func selectedCard(at index: Int) {
        if !cards[index].isMatch {
            if let matchIndex = indexOfSelectedCard, matchIndex != index {
                if cards[matchIndex] == cards[index] {
                    cards[matchIndex].isMatch = true
                    cards[index].isMatch = true
                    score += 2
                } else if cards[index].hasBeenSaw  == true {
                    score -= 1
                }
                cards[index].isfaceUP = true
                flipCount += 1
            } else {
                indexOfSelectedCard = index
                cards[index].hasBeenSaw = true
                flipCount += 1
            }
        }
    }
    
  
    
    init (numberOfPairsOfCards: Int) {
        // create the pairs of cars that will be use in the concentration game
        for _ in 0..<numberOfPairsOfCards {
            let card = Card()
            cards += [card, card]
        }
        // shuffle the cards
        cards = cards.shuffled()
    }
    //MARK: - End of ConcentrationGameBrainModel
}
