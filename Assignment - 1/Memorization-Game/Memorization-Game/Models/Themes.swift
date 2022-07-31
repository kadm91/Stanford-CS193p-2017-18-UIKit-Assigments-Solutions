//
//  Themes.swift
//  Memorization-Game
//
//  Created by Kevin Martinez on 4/3/22.
//

import Foundation
import UIKit


struct Themes{
    
    let name: String
    let emoji: [String]
    
    let backGroundColor: UIColor
    let borderOfCardColor:CGColor
    let backOfCardColor: UIColor
    let themeButtomBackground: UIColor
    
    
    
    
    private static let vehiclesTheme = Themes(
        name: "Vehicles",
        emoji: ["🚗", "🚕", "🚙", "🚌", "🚎", "🏎", "🚓", "🚑", "🚒", "🚐", "🛻", "🚜", "🛵", "🏍", "🛺", "✈️"],
        backGroundColor: .darkGray,
        borderOfCardColor: UIColor.black.cgColor,
        backOfCardColor: .systemRed,
        themeButtomBackground: .gray)
    
    private static let plansTheme = Themes(
        name: "Plans",
        emoji: ["🌵", "🌲", "🌳", "🌴", "🌱", "☘️", "🌿", "🪴", "🎋", "💐", "🌹", "🌻", "🌸", "🪷", "🌼", "🌾", "🎍", "🌺", "🌷", "🍁 ", "🥀 ", "🍂", "🪵"],
        backGroundColor: UIColor.systemMint,
        borderOfCardColor: UIColor.systemPurple.cgColor,
        backOfCardColor: UIColor.systemOrange,
        themeButtomBackground: UIColor.systemPurple)
    
    private static let facesTheme = Themes(
        name: "Faces",
        emoji: ["😀", "🥹", "😂", "🥲", "😇", "🧐", "🤓", "😎", "🥸", "🤩", "🥳", "😤", "😭", "🤯", "😡", "😷", "😶‍🌫️", "🫥", "🤠", "🤑 ", "🤒 ", "😵‍💫", "🥶"], backGroundColor: UIColor.systemIndigo,
        borderOfCardColor: UIColor.systemGray.cgColor,
        backOfCardColor: UIColor.purple,
        themeButtomBackground: UIColor.magenta)
    
    
    private static let foodTheme = Themes(
        name: "Food",
        emoji: ["🍏", "🍎", "🍐", "🍳", "🥓", "🥩", "🍔", "🍟", "🍕", "🥪", "🌮", "🌯", "🥗", "🍿", "🥡", "🍤", "🍫", "🧋", "☕️", "🌭", "🥝", "🧀", "🍍"], backGroundColor: UIColor(red: 192/255, green: 216/255,blue: 192/255, alpha: 1),
        borderOfCardColor: UIColor(red: 245/255, green: 238/255, blue: 220/255, alpha: 1).cgColor,
        backOfCardColor: UIColor(red: 236/255, green: 179/255, blue: 144/255, alpha: 1),
        themeButtomBackground: UIColor(red: 221/255, green: 74/255, blue: 72/255, alpha: 1))
    
    
    private static let sportTheme = Themes(name: "Sports", emoji: ["⚽️", "🏀", "🏈", "⚾️", "🎱", "🏒", "🛹", "🥋", "🏹", "🥅", "🤿", "🥊", "🛼", "🛷", "⛸", "🥌", "🏂", "🪂", "🏄‍♂️", "🏊‍♀️", "🚣‍♀️", "🚴‍♂️", "🎿"], backGroundColor: UIColor(red: 26/255, green: 38/255, blue: 91/255, alpha: 1), borderOfCardColor: UIColor(red: 241/255, green: 97/255, blue: 13/255, alpha: 1).cgColor, backOfCardColor: UIColor(red: 80/255, green: 165/255, blue: 175/255, alpha: 1), themeButtomBackground: UIColor(red: 255/255, green: 245/255, blue: 237/255, alpha: 1))
    
    private static let animalsTheme = Themes(name: "Animals", emoji: ["🐶", "🐱", "🐭", "🐹", "🐰", "🦊", "🐻", "🐼", "🐨", "🦁", "🐮", "🐷", "🐸", "🐵", "🐔", "🐧", "🐣", "🦆", "🦇", "🐍", "🦣", "🐊", "🦖"], backGroundColor: UIColor(red: 208/255, green: 118/255, blue: 76/255, alpha: 1), borderOfCardColor: CGColor(red: 122/255, green: 108/255, blue: 97/255, alpha: 1), backOfCardColor: UIColor(red: 44/255, green: 80/255, blue: 107/255, alpha: 1), themeButtomBackground: UIColor(red: 233/255, green: 177/255, blue: 103/255, alpha: 1))
    
    
    static let themes = [vehiclesTheme, plansTheme, facesTheme, foodTheme, sportTheme, animalsTheme]
    
    
    
}
