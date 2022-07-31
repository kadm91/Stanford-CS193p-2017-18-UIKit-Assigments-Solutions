//
//  CardModel.swift
//  Consentration-And-Animated-Set-Games
//
//  Created by Kevin Martinez on 5/27/22.
//

import Foundation

typealias Card = CardModel

/** Card Structure for each card in concentration game */
struct CardModel: Hashable {
    
    //MARK: - Hashable & Equablable implementation
    func hash(into hasher: inout Hasher) {
        id.hash(into: &hasher)
    }
    
    static func ==(lhs: CardModel, rhs: CardModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    //MARK: - Properties
    
    /** Keep track if the cartd is face-up or face-down */
    var isfaceUP = false
    /** Records if the card have been matched or not */
    var isMatch = false
    /**keep track if a card has been saw but not match to deduct the game score*/
    var hasBeenSaw = false
    /** Unique Id for each pair of cards created to compared them using Hashable protocol */
    private var id: Int
    /** Starting count for the id of each pair of cards, every time a Card object is created */
    private static var assignId = 0
 
    
    //MARK: - Functions
    /**
     Creates an unique id in sequence for each pair of cards
     
     - Returns: An Unique Int used as the Id of each pair of cards to do the matching using Hashable and Equablable Protocols
     */
    private static func createId() -> Int {
        assignId += 1
        return assignId
    }
    
    //MARK: - Init
    init(){
        self.id = CardModel.createId()
    }
    
    //MARK: - End of Card Structure
}
