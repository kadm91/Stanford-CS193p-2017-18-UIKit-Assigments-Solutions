//
//  SetCardModel.swift
//  Consentration-And-Animated-Set-Games
//
//  Created by Kevin Martinez on 5/29/22.
//

import Foundation

/**Card Model for the set card that represent each set card for ist attribures: Symbol, Number, Color and Shade.*/
struct SetCard {
    
    /**The symbol in each Set Card*/
    private (set) var symbol: Symbol
    /**The Number of Symbols in each Set Card*/
    private (set) var numberOfSymbols: NumerOfSymbols
    /**The Shadding of the symbol in each Set Card*/
    private (set) var symbolShadding: SymbolShading
    /**The Color of the Symbol in each Set Card*/
    private (set) var symbolColor: SymbolColor
    
    enum Symbol: String {
        case squiggle
        case oval
        case diamon
        
        private (set) static var allOptions: [Symbol] = [.squiggle, .oval, .diamon]
    }
    
    enum SymbolShading: String {
        case empty
        case fill
        case lines
        
        private (set)  static var allOptions: [SymbolShading] = [.empty, .fill, .lines]
    }
    
    enum NumerOfSymbols: String {
        case one
        case two
        case three
        
        private (set)   static var allOptions: [NumerOfSymbols] = [.one, .two, .three]
    }
    
    enum SymbolColor: String {
        case green
        case red
        case blue
        
        private (set) static var allOptions: [SymbolColor] = [.green, .red, .blue]
    }
    
    //MARK: - End of SetCardModel
}
