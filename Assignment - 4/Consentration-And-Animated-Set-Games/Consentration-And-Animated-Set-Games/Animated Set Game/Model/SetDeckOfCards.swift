//
//  SetDeckOfCards.swift
//  Consentration-And-Animated-Set-Games
//
//  Created by Kevin Martinez on 5/29/22.
//

import Foundation

/**
 Creates the deck from the SetCard model
 */
struct SetDeckOfCards {
    
    
    /** Computed propertie that creates the deck from the SetCard model. */
    private (set) var deck = [SetCard]()
    
    init() {
        for symbol in SetCard.Symbol.allOptions {
            for number in SetCard.NumerOfSymbols.allOptions {
                for shading in SetCard.SymbolShading.allOptions {
                    for color in SetCard.SymbolColor.allOptions {
                        deck.append(SetCard(
                            symbol: symbol,
                            numberOfSymbols: number,
                            symbolShadding: shading,
                            symbolColor: color
                        ))
                    }
                }
            }
        }
        // alway return teh deck of set cards shuffled so we don't have to shuffle in other part or the app.
        deck.shuffle()
    }
    //MARK: - end of SetDeckCrads
}
