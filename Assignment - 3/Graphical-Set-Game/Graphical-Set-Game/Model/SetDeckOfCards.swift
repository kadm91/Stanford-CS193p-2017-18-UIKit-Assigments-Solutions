//
//  SetDeckOfCards.swift
//  Graphical-Set-Game
//
//  Created by Kevin Martinez on 5/8/22.
//

import Foundation

/**
 Creates the deck from the SetCard model
 */
struct SetDeckOfCards {
    
    /**
     Computed propertie that creates the deck from the SetCard model
     */
private (set) var deck = [SetCard]()
  
    init() {
        for symbol in card.Symbol.allOptions {
            for number in card.NumberOfSymbols.allOptions {
                for shading in card.SymbolShading.allOptions {
                    for color in card.SymbolColor.allOptions {
                        deck.append(SetCard(symbol: symbol, numberOfSymbols: number, symbolshadding: shading, symbolColor: color))
                    }
                }
            }
        }
        deck.shuffle()
    }
}
