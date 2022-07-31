//
//  Card.swift
//  Card Game Set
//
//  Created by Kevin Martinez on 4/15/22.
//

import Foundation


struct Card: Equatable {
    
    var symbol: Symbol
    var numberOfSymbols: NumberOfSymbols
    var shading: Shading
    var symbolColor: SymbolColor
    var isMatch: Bool = false
    var selectedCar: Bool = false
    
    enum Symbol {
        
        case oval
        case square
        case triangle
        
        static var allSymbols: [Symbol] = [.oval, .square, .triangle]
    }
    
    enum Shading: String {
        case solid
        case empty
        case strips
        
        static var allShading: [Shading] = [.solid, .empty, .strips]
    }
    
    enum NumberOfSymbols {
        
        case one
        case two
        case three
        
        static var allNumberOfSymbols: [NumberOfSymbols] = [.one, .two, .three]
    }
    
    enum SymbolColor  {
        case green
        case red
        case blue
        
        static var allColors: [SymbolColor] = [.green, .red, .blue]
    }
}
