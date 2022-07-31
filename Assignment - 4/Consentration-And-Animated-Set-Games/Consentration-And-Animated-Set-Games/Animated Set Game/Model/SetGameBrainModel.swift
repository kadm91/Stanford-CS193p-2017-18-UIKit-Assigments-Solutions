//
//  SetGameBrain.swift
//  Consentration-And-Animated-Set-Games
//
//  Created by Kevin Martinez on 5/29/22.
//

import Foundation

/**
 Model for the mechanics of the Set Card Game.
 */
struct SetGameBrainModel {
    
    //MARK: - Init()
    
    init() {
        // add the index of the cards from the deck to the availableCardOnGame to search the actual card into the deck just using its index
        for index in deck.indices {
            availableCardsOnDeck.append(index)
        }
        // remove cards from the availableCardsOnDeck to the CardOnGame Array.
        dealCardsToCardGame(numberOfCardDeal: K.startingNumberOfCards)
    }
    
    //MARK: - Properties
    
    /** The deck created with setCard model. */
    private (set) var deck = SetDeckOfCards().deck
    
    /** The index of each card in the deck array. */
    private (set) var availableCardsOnDeck = [Int]()
    
    /** The index of the cards in game remove from available cardsOnDeck array to refered to the card in the deck array. */
    private (set) var cardOnGame = [Int]() //
    
    /** After a match is true this the index of this match are move here to keep count of those matches.   */
    private (set) var matchedCards = [Int]()
    
    /** Array of selected cards to evaluate if thy make a match. */
    var selectedCards = [Int]() //
    
    /** Score 3 points if a set is found or take 1 point if a set is mis smatch. */
    private (set) var score = 0 //
    
    /** The percentage of Set Found, There is a total of 27 set in this game*/
    private (set)var percentageCompleted = 0.0
    
    
    //MARK: - Methods
    
    /**
     Reshuffle the Cards in the same game.
     - parameters:
     - numberOFCardToREshuffle: takes and integer that is use to put the same amoung of cards that were in the game before reshuffle
     */
    mutating func reshufleCards(numberOFCardToREshuffle: Int){
        
        if availableCardsOnDeck.count > numberOFCardToREshuffle {
            availableCardsOnDeck.append(contentsOf: cardOnGame)
            cardOnGame.removeAll()
            dealCardsToCardGame(numberOfCardDeal: numberOFCardToREshuffle)
        } else {
            print("there is not enought available cards to reshuffle")
        }
        
    }
    
    /**
     Evaluates if the 3 selected cards make a match set or not
     - parameters:
     - card: the selected cards view tag value to look for it in the available cards after selecting three cards it make is the evaluation before that the selected cards are add to the selectedCards array.
     
     - Returns: A optional Bool? used in the ViewController to code what happen whether there is a match set.
     */
    mutating func selectedCardsEvaluation(on card: Int) -> Bool?  {
        
        if selectedCards.contains(card){
            let indexOfSelectedCard = selectedCards.firstIndex(of: card)
            selectedCards.remove(at: indexOfSelectedCard!)
            
        } else if selectedCards.count < 2{
            selectedCards.append(card)
            
        } else if selectedCards.count <= 3 {
            
            selectedCards.append(card)
            
            if checkForMatchedSet() == true {
                for card in selectedCards {
                    guard let indexOfcard = cardOnGame.firstIndex(of: card) else {break}
                    matchedCards.append(card)
                    cardOnGame.remove(at: indexOfcard)
                }
                
                score += K.addToScore
                let completedSets = Double(matchedCards.count)
                let totalNumberOfCards = Double(deck.count)
                percentageCompleted = (completedSets / totalNumberOfCards) * K.HundredPercent
                return true
                
            } else {
                selectedCards.removeAll()
                score -= K.substractFromScore
                return false
            }
        }
        return nil
        
    }
    
    /**
     Deals three more cards into the game as long there is at least 3 cards in the availableCardOnGameDeck array.
     */
    mutating func deal3MoreCards() {
        if availableCardsOnDeck.count >= 3 {
            dealCardsToCardGame(numberOfCardDeal: K.threeCards)
            
        }
    }
    
    /**
     Deals the specified number of cards into  the CardOnGame array from the availableCardOnDeck Array
     - parameters:
     - numberOfCardDeal: the number of cards that we want to deal into the game
     */
    private mutating func dealCardsToCardGame(numberOfCardDeal: Int) {
        for _ in 1...numberOfCardDeal {
            let randomIndex = Int(arc4random_uniform(UInt32(availableCardsOnDeck.count-1)))
            let cardIndex = availableCardsOnDeck.remove(at: randomIndex)
            cardOnGame += [cardIndex]
        }
    }
    
    /**
     Once three cards are in the selected card array this function is call inside the selectedCardsEvaluation method to check those cards make a match or not.
     - Returns: A Bool to know if either the three selected card where a match or not
     */
    private func checkForMatchedSet() -> Bool {
        
        // evaluates the selected cards
        func setEvaluation (card1: SetCard, card2: SetCard, card3: SetCard) -> Bool {
            // the rules that either make a set match or not
            func matchSetRules(attribute1: String, attribute2: String, attribute3: String) -> Bool {
                if attribute1 == attribute2 && attribute2 == attribute3 {
                    return  true
                } else if attribute1 != attribute2 && attribute2 != attribute3 {
                    return true
                } else {
                    return false
                }
            }
            
            let evaluateSymbol = matchSetRules(
                attribute1: card1.symbol.rawValue,
                attribute2: card2.symbol.rawValue,
                attribute3: card3.symbol.rawValue
            )
            let evaluateShadding = matchSetRules(
                attribute1: card1.symbolShadding.rawValue,
                attribute2: card2.symbolShadding.rawValue,
                attribute3: card3.symbolShadding.rawValue
            )
            let evaluteNumber = matchSetRules(
                attribute1: card1.numberOfSymbols.rawValue,
                attribute2: card2.numberOfSymbols.rawValue,
                attribute3: card3.numberOfSymbols.rawValue
            )
            let evaluateColor =  matchSetRules(
                attribute1: card1.symbolColor.rawValue,
                attribute2: card2.symbolColor.rawValue,
                attribute3: card3.symbolColor.rawValue
            )

            return (evaluateShadding && evaluateSymbol) && (evaluteNumber && evaluateColor)
            
            
//            // use this just to evaluate the color to make testing quickly for full game uncomment code above and comment code below
//            let evaluateColor =  matchSetRules(
//                attribute1: card1.symbolColor.rawValue,
//                attribute2: card2.symbolColor.rawValue,
//                attribute3: card3.symbolColor.rawValue
//            )
//            return evaluateColor
            
        }
        
        // look for the selected cards in the deck
        let selectedCard1 = deck[selectedCards[0]]
        let selectedCard2 = deck[selectedCards[1]]
        let selectedCard3 = deck[selectedCards[2]]
        
        return setEvaluation(card1: selectedCard1, card2: selectedCard2, card3: selectedCard3)
    }
    
   //MARK: - Constnts for SetGameBrainModel
    private struct K {
        static let startingNumberOfCards = 12
        static let HundredPercent = 100.0
        static let threeCards = 3
        static let addToScore = 3
        static let substractFromScore = 1
        
    }
    //MARK: - End of class SetGameBrainModel
}
