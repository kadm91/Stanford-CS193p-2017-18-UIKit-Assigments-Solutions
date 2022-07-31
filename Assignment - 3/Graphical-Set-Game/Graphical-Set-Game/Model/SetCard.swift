//
//  SetCardModel.swift
//  Graphical-Set-Game
//
//  Created by Kevin Martinez on 5/8/22.
//

/**
 typeAlias created to refer to the created struc SetCard type below
 */
typealias card = SetCard

/**
 Card Model for the set cart that representatetes the set card four attirbures: Symbol, Number, Color and Shade.
 */
struct SetCard {
    
    private (set) var symbol: Symbol
    private (set)var numberOfSymbols: NumberOfSymbols
    private (set) var symbolshadding: SymbolShading
    private (set) var symbolColor: SymbolColor
    
    
    enum Symbol: String {
        
        case squiggle
        case oval
        case diamon
        
        static var allOptions: [Symbol] = [.oval, .squiggle, .diamon]
    }
    
    enum SymbolShading: String {
        case empty
        case fill
        case lines
        
        private (set) static var allOptions: [SymbolShading] = [.fill, .empty, .lines]
    }
    
    enum NumberOfSymbols: String {
        
        case one
        case two
        case three
        
        private (set)  static var allOptions: [NumberOfSymbols] = [.one, .two, .three]
    }
    
    enum SymbolColor: String  {
        case green
        case red
        case blue
        
        private (set)  static var allOptions: [SymbolColor] = [.green, .red, .blue]
    }
}
