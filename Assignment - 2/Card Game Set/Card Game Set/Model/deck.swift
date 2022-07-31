//
//  Deck.swift
//  Card Game Set
//
//  Created by Kevin Martinez on 4/20/22.
//

import Foundation

struct Deck {
    
    private (set) var deck = [Card]()
    
    init(){
        
        for symbol in Card.Symbol.allSymbols {
            for number in Card.NumberOfSymbols.allNumberOfSymbols {
                for shading in Card.Shading.allShading{
                    for SymbolColor in Card.SymbolColor.allColors {
                        deck.append(Card(symbol: symbol, numberOfSymbols: number, shading: shading, symbolColor: SymbolColor))
                    }
                }
            }
        }
        deck.shuffle()
    }
    
    mutating func draw(numberOfCardsToDraw number: Int) -> [Card] {
        var cards: [Card] = []
        
        for _ in 0..<number {
            if let aCard =  deck.popLast(){
                cards.append(aCard)
            }
        }
        return cards
    }
}
