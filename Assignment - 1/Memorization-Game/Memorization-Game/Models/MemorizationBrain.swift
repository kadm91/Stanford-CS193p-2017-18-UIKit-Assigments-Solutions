//
//  MemorizationModel.swift
//  Memorization-Game
//
//  Created by Kevin Martinez on 4/2/22.
//

import Foundation

struct MemorizationBrain {
    
    var cards = [Card]()
    private(set) var flipCount = 0
    private(set) var Score = 0
    
    private var indexOfSelectedCard: Int?{
        get{
            var selectedCardIndex: Int?
 
            for index in cards.indices {
                if cards[index].isFaceUp{
                    if selectedCardIndex == nil {
                        selectedCardIndex = index
                     
                    }else {
                        return nil
                }
                }
            }
            
            return selectedCardIndex
        }
        set {
          
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
               
            }
            
        }
    }
    
   mutating  func selectedCard(at index: Int){
        
        if !cards[index].isMatch {
         
        if let matchIndex = indexOfSelectedCard, matchIndex != index {
           
            if cards[matchIndex] == cards[index] {
              
                cards[matchIndex].isMatch = true
                cards[index].isMatch = true
                Score += 2
                
            } else if cards[index].hasBeenSaw == true {
                Score -= 1
            }
              
            cards[index].isFaceUp = true
            flipCount += 1
            
            
        } else {
           
            indexOfSelectedCard = index
            cards[index].hasBeenSaw = true
            flipCount += 1
        }
            
    
        
    }
    }
    
    
    
    init (numberOfPairsOFCards: Int) {
        
        for _ in 0..<numberOfPairsOFCards {
            let card = Card()
            cards += [card, card]
        }
        cards = cards.shuffled()
    }
    
}
