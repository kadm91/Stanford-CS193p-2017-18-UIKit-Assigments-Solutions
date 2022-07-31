//
//  Card.swift
//  Memorization-Game
//
//  Created by Kevin Martinez on 4/2/22.
//

import Foundation

struct Card: Hashable{
    
    func hash(into hasher: inout Hasher)  {
        id.hash(into: &hasher)
    }

    static func == (lhs: Card, rhs: Card) -> Bool{
        return lhs.id == rhs.id
    }
    
    var isFaceUp = false
    var isMatch = false
    var hasBeenSaw = false
    private var id: Int
    
    private static var assignId = 0
    private static func createUniqueId() -> Int {
        assignId += 1
        return assignId
    }
    
    init(){
        self.id = Card.createUniqueId()
    }
}
