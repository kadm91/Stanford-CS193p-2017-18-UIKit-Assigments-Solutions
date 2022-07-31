//
//  SelectedCardEvaluationModel.swift
//  Card Game Set
//
//  Created by Kevin Martinez on 4/25/22.
//

//TODO: Refactore this code for real lol 😅

import Foundation

struct SelectedCardEvaluationMode {
    static func isASet(card1: Card, card2: Card, card3: Card) -> Bool {
        if
            // Just color is the same
                card1.symbolColor == card2.symbolColor && card1.symbolColor == card3.symbolColor && card2.symbolColor == card3.symbolColor &&
                card1.symbol != card2.symbol && card1.symbol != card3.symbol && card2.symbol != card3.symbol &&
                card1.numberOfSymbols != card2.numberOfSymbols && card1.numberOfSymbols != card3.numberOfSymbols && card2.numberOfSymbols != card3.numberOfSymbols &&
                card1.shading != card2.shading && card1.shading != card3.shading && card2.shading != card3.shading ||
                // just symbol is the same
                card1.symbol == card2.symbol && card1.symbol == card3.symbol && card2.symbol == card3.symbol &&
                card1.symbolColor != card2.symbolColor && card1.symbolColor != card3.symbolColor && card2.symbolColor != card3.symbolColor &&
                card1.numberOfSymbols != card2.numberOfSymbols && card1.numberOfSymbols != card3.numberOfSymbols && card2.numberOfSymbols != card3.numberOfSymbols &&
                card1.shading != card2.shading && card1.shading != card3.shading && card2.shading != card3.shading ||
                
                // just number of simbol is the same
                card1.symbol != card2.symbol && card1.symbol != card3.symbol && card2.symbol != card3.symbol &&
                card1.symbolColor != card2.symbolColor && card1.symbolColor != card3.symbolColor && card2.symbolColor != card3.symbolColor &&
                card1.numberOfSymbols == card2.numberOfSymbols && card1.numberOfSymbols == card3.numberOfSymbols && card2.numberOfSymbols == card3.numberOfSymbols &&
                card1.shading != card2.shading && card1.shading != card3.shading && card2.shading != card3.shading ||
                
                // just shadding is the same
                card1.symbol != card2.symbol && card1.symbol != card3.symbol && card2.symbol != card3.symbol &&
                card1.symbolColor != card2.symbolColor && card1.symbolColor != card3.symbolColor && card2.symbolColor != card3.symbolColor &&
                card1.numberOfSymbols != card2.numberOfSymbols && card1.numberOfSymbols != card3.numberOfSymbols && card2.numberOfSymbols != card3.numberOfSymbols &&
                card1.shading == card2.shading && card1.shading == card3.shading && card2.shading == card3.shading ||
                
                // color and symbol are the same
                card1.symbol == card2.symbol && card1.symbol == card3.symbol && card2.symbol == card3.symbol &&
                card1.symbolColor == card2.symbolColor && card1.symbolColor == card3.symbolColor && card2.symbolColor == card3.symbolColor &&
                card1.numberOfSymbols != card2.numberOfSymbols && card1.numberOfSymbols != card3.numberOfSymbols && card2.numberOfSymbols != card3.numberOfSymbols &&
                card1.shading != card2.shading && card1.shading != card3.shading && card2.shading != card3.shading ||
                
                // color and number of symbols are the same
                card1.symbol != card2.symbol && card1.symbol != card3.symbol && card2.symbol != card3.symbol &&
                card1.symbolColor == card2.symbolColor && card1.symbolColor == card3.symbolColor && card2.symbolColor == card3.symbolColor &&
                card1.numberOfSymbols == card2.numberOfSymbols && card1.numberOfSymbols == card3.numberOfSymbols && card2.numberOfSymbols == card3.numberOfSymbols &&
                card1.shading != card2.shading && card1.shading != card3.shading && card2.shading != card3.shading ||
                
                // color and shading are the same
                card1.symbol != card2.symbol && card1.symbol != card3.symbol && card2.symbol != card3.symbol &&
                card1.symbolColor == card2.symbolColor && card1.symbolColor == card3.symbolColor && card2.symbolColor == card3.symbolColor &&
                card1.numberOfSymbols != card2.numberOfSymbols && card1.numberOfSymbols != card3.numberOfSymbols && card2.numberOfSymbols != card3.numberOfSymbols &&
                card1.shading == card2.shading && card1.shading == card3.shading && card2.shading == card3.shading ||
                
                
                // symbol and number of symbol is the same
                card1.symbol == card2.symbol && card1.symbol == card3.symbol && card2.symbol == card3.symbol &&
                card1.symbolColor != card2.symbolColor && card1.symbolColor != card3.symbolColor && card2.symbolColor != card3.symbolColor &&
                card1.numberOfSymbols == card2.numberOfSymbols && card1.numberOfSymbols == card3.numberOfSymbols && card2.numberOfSymbols == card3.numberOfSymbols &&
                card1.shading != card2.shading && card1.shading != card3.shading && card2.shading != card3.shading ||
                
                
                // symbol and shading is the same
                card1.symbol == card2.symbol && card1.symbol == card3.symbol && card2.symbol == card3.symbol &&
                card1.symbolColor != card2.symbolColor && card1.symbolColor != card3.symbolColor && card2.symbolColor != card3.symbolColor &&
                card1.numberOfSymbols != card2.numberOfSymbols && card1.numberOfSymbols != card3.numberOfSymbols && card2.numberOfSymbols != card3.numberOfSymbols &&
                card1.shading == card2.shading && card1.shading == card3.shading && card2.shading == card3.shading ||
                
                // number and shading are the same
                card1.symbol != card2.symbol && card1.symbol != card3.symbol && card2.symbol != card3.symbol &&
                card1.symbolColor != card2.symbolColor && card1.symbolColor != card3.symbolColor && card2.symbolColor != card3.symbolColor &&
                card1.numberOfSymbols == card2.numberOfSymbols && card1.numberOfSymbols == card3.numberOfSymbols && card2.numberOfSymbols == card3.numberOfSymbols &&
                card1.shading == card2.shading && card1.shading == card3.shading && card2.shading == card3.shading ||
                
                // color , symbol and number are the same
                card1.symbol == card2.symbol && card1.symbol == card3.symbol && card2.symbol == card3.symbol &&
                card1.symbolColor == card2.symbolColor && card1.symbolColor == card3.symbolColor && card2.symbolColor == card3.symbolColor &&
                card1.numberOfSymbols == card2.numberOfSymbols && card1.numberOfSymbols == card3.numberOfSymbols && card2.numberOfSymbols == card3.numberOfSymbols &&
                card1.shading != card2.shading && card1.shading != card3.shading && card2.shading != card3.shading ||
                
                // symbol, number and shadding are the same
                card1.symbol == card2.symbol && card1.symbol == card3.symbol && card2.symbol == card3.symbol &&
                card1.symbolColor != card2.symbolColor && card1.symbolColor != card3.symbolColor && card2.symbolColor != card3.symbolColor &&
                card1.numberOfSymbols == card2.numberOfSymbols && card1.numberOfSymbols == card3.numberOfSymbols && card2.numberOfSymbols == card3.numberOfSymbols &&
                card1.shading == card2.shading && card1.shading == card3.shading && card2.shading == card3.shading ||
                
                // number, shading and color are the same
                card1.symbol != card2.symbol && card1.symbol != card3.symbol && card2.symbol != card3.symbol &&
                card1.symbolColor == card2.symbolColor && card1.symbolColor == card3.symbolColor && card2.symbolColor == card3.symbolColor &&
                card1.numberOfSymbols == card2.numberOfSymbols && card1.numberOfSymbols == card3.numberOfSymbols && card2.numberOfSymbols == card3.numberOfSymbols &&
                card1.shading == card2.shading && card1.shading == card3.shading && card2.shading == card3.shading ||
                // shading, color, symbol are the same
                card1.symbol == card2.symbol && card1.symbol == card3.symbol && card2.symbol == card3.symbol &&
                card1.symbolColor == card2.symbolColor && card1.symbolColor == card3.symbolColor && card2.symbolColor == card3.symbolColor &&
                card1.numberOfSymbols != card2.numberOfSymbols && card1.numberOfSymbols != card3.numberOfSymbols && card2.numberOfSymbols != card3.numberOfSymbols &&
                card1.shading == card2.shading && card1.shading == card3.shading && card2.shading == card3.shading ||
                
                
                // all 4 are the same
                card1.symbol == card2.symbol && card1.symbol == card3.symbol && card2.symbol == card3.symbol &&
                card1.symbolColor == card2.symbolColor && card1.symbolColor == card3.symbolColor && card2.symbolColor == card3.symbolColor &&
                card1.numberOfSymbols == card2.numberOfSymbols && card1.numberOfSymbols == card3.numberOfSymbols && card2.numberOfSymbols == card3.numberOfSymbols &&
                card1.shading == card2.shading && card1.shading == card3.shading && card2.shading == card3.shading ||
                // all 4 are diferent
                card1.symbol != card2.symbol && card1.symbol != card3.symbol && card2.symbol != card3.symbol &&
                card1.symbolColor != card2.symbolColor && card1.symbolColor != card3.symbolColor && card2.symbolColor != card3.symbolColor &&
                card1.numberOfSymbols != card2.numberOfSymbols && card1.numberOfSymbols != card3.numberOfSymbols && card2.numberOfSymbols != card3.numberOfSymbols &&
                card1.shading != card2.shading && card1.shading != card3.shading && card2.shading != card3.shading
                
        {
            return true
        } else {
            return false
        }
        
    }
}
