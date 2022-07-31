//
//  DeckOfCards.swift
//  Card Game Set
//
//  Created by Kevin Martinez on 4/15/22.
//

import Foundation
import UIKit

struct setGameBrain {
    
    private (set) var persentageCompleted = 0.0
    private var matchingSets = 0.0
    private (set) var score = 0
    private (set) var deck = Deck()
    private (set) var gameCards: [Card]
    
    init () {
        gameCards = deck.draw(numberOfCardsToDraw: 24)
    }
    
    private(set) var selectedCards = [Card]()
    private (set) var indexesOfSelectedCards = [Int]()
    private(set) var matchesCards = [Card]()
    
    var matchesCardButtonIndeces = [Int]()
    
    mutating func draw3cards() {
        if deck.deck.count >= 3 {
            gameCards += deck.draw(numberOfCardsToDraw: 3)
        }
    }
    
    mutating func selectedCardFunction(at index: Int){
        
        if indexesOfSelectedCards.contains(index) {
            
            let chosenCard = gameCards[index]
            let indexOfChosenCardInSelectedCardsArry = selectedCards.firstIndex(of: chosenCard)
            let indexOfChosenCardInIdexesOfSelectedCards = indexesOfSelectedCards.firstIndex(of: index)
            gameCards[index].selectedCar =  false
            indexesOfSelectedCards.remove(at:indexOfChosenCardInIdexesOfSelectedCards!)
            selectedCards.remove(at: indexOfChosenCardInSelectedCardsArry!)
            
        } else if selectedCards.count < 2  {
            
            
            gameCards[index].selectedCar = true
            selectedCards.append(gameCards[index])
            indexesOfSelectedCards.append(index)
            
            
        } else if selectedCards.count < 3 {
            gameCards[index].selectedCar = true
            selectedCards.append(gameCards[index])
            indexesOfSelectedCards.append(index)
            
            let card1 = selectedCards[0]
            let card2 = selectedCards[1]
            let card3 = selectedCards[2]
            
            let evaluation = SelectedCardEvaluationMode.isASet(card1: card1, card2: card2, card3: card3)
            
            if evaluation {
                
                score += 3
                matchingSets += 1
                persentageCompleted = (matchingSets / 27) * 100
                
                for index in indexesOfSelectedCards {
                
                    gameCards[index].isMatch = true
                    matchesCards = (gameCards.filter{$0 .isMatch == true})
                    matchesCardButtonIndeces.append(index)
                }
                
                selectedCards.removeAll()
                indexesOfSelectedCards.removeAll()
                
            } else {
                score -= 2
                for index in indexesOfSelectedCards {
                    gameCards[index].selectedCar = false
                }
                selectedCards.removeAll()
                indexesOfSelectedCards.removeAll()
            }
        }
    }
    
    mutating func dealCards() {
        
        if deck.deck.count >= 3 {
            
            for index in gameCards.indices {
                gameCards[index].isMatch = false
                gameCards[index].selectedCar = false
                indexesOfSelectedCards.removeAll()
            }
            
            for index in matchesCardButtonIndeces {
                gameCards.remove(at: index)
                gameCards.insert(contentsOf: deck.draw(numberOfCardsToDraw: 1), at: index)
                var card = gameCards[index]
                card.isMatch = false
            }
        }
    }
}



