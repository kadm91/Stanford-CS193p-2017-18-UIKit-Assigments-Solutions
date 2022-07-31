//
//  ThemeModel.swift
//  Consentration-And-Animated-Set-Games
//
//  Created by Kevin Martinez on 5/27/22.
//

import Foundation
import UIKit

typealias Theme = ThemesModel

/**The model for the diferent themes using in concentration game*/
struct ThemesModel {
    //MARK: - Properties
    
    /**The name of the Theme*/
    let name: String
    /**The emojies to be use depending of the chossen theme*/
    let emoji: [String]
    /**The background Color depending of the chossen theme*/
    let backgroundColor: UIColor
    /**The border of the card depending of the chossen theme*/
    let cardborderColor: CGColor
    /**The background color of the back of the card when is face-down deppeding of the chossen theme*/
    let backOfCardColor: UIColor
    
    //MARK: - Themes Creation
    
    /** A Theme based on vehicles*/
    private (set) static var vehiclesTheme = ThemesModel(
        name: "Vehicles",
        emoji: ["🚗", "🚕", "🚙", "🚌", "🚎", "🏎", "🚓", "🚑", "🚒", "🚐", "🛻", "🚜", "🛵", "🏍", "🛺", "✈️"],
        backgroundColor: .darkGray,
        cardborderColor: UIColor.black.cgColor,
        backOfCardColor: .systemRed
    )
    /** A Theme based on plans*/
    private (set) static var plansTheme = ThemesModel(
        name: "Plans",
        emoji: ["🌵", "🌲", "🌳", "🌴", "🌱", "☘️", "🌿", "🪴", "🎋", "💐", "🌹", "🌻", "🌸", "🪷", "🌼", "🌾", "🎍", "🌺", "🌷", "🍁 ", "🥀 ", "🍂", "🪵"],
        backgroundColor: UIColor.systemMint,
        cardborderColor: UIColor.systemPurple.cgColor,
        backOfCardColor: UIColor.systemOrange
    )
    /** A Theme based on emoji faces*/
    private (set) static var facesTheme = ThemesModel(
        name: "Faces",
        emoji: ["😀", "🥹", "😂", "🥲", "😇", "🧐", "🤓", "😎", "🥸", "🤩", "🥳", "😤", "😭", "🤯", "😡", "😷", "😶‍🌫️", "🫥", "🤠", "🤑 ", "🤒 ", "😵‍💫", "🥶"],
        backgroundColor: UIColor.systemIndigo,
        cardborderColor: UIColor.systemGray.cgColor,
        backOfCardColor: UIColor.purple
    )
    
    /** A Theme based on food */
    private (set) static var foodTheme = ThemesModel(
        name: "Food",
        emoji: ["🍏", "🍎", "🍐", "🍳", "🥓", "🥩", "🍔", "🍟", "🍕", "🥪", "🌮", "🌯", "🥗", "🍿", "🥡", "🍤", "🍫", "🧋", "☕️", "🌭", "🥝", "🧀", "🍍"],
        backgroundColor: UIColor(red: 192/255, green: 216/255,blue: 192/255, alpha: 1),
        cardborderColor: UIColor(red: 245/255, green: 238/255, blue: 220/255, alpha: 1).cgColor,
        backOfCardColor: UIColor(red: 236/255, green: 179/255, blue: 144/255, alpha: 1)
    )
    
    /** A Theme based on sports*/
    private (set) static var sportTheme = ThemesModel(
        name: "Sports", emoji: ["⚽️", "🏀", "🏈", "⚾️", "🎱", "🏒", "🛹", "🥋", "🏹", "🥅", "🤿", "🥊", "🛼", "🛷", "⛸", "🥌", "🏂", "🪂", "🏄‍♂️", "🏊‍♀️", "🚣‍♀️", "🚴‍♂️", "🎿"],
        backgroundColor: UIColor(red: 26/255, green: 38/255, blue: 91/255, alpha: 1),
        cardborderColor: UIColor(red: 241/255, green: 97/255, blue: 13/255, alpha: 1).cgColor,
        backOfCardColor: UIColor(red: 80/255, green: 165/255, blue: 175/255, alpha: 1)
    )
    /** A Theme based on animals*/
    private (set) static var animalsTheme = ThemesModel(
        name: "Animals", emoji: ["🐶", "🐱", "🐭", "🐹", "🐰", "🦊", "🐻", "🐼", "🐨", "🦁", "🐮", "🐷", "🐸", "🐵", "🐔", "🐧", "🐣", "🦆", "🦇", "🐍", "🦣", "🐊", "🦖"],
        backgroundColor: UIColor(red: 208/255, green: 118/255, blue: 76/255, alpha: 1),
        cardborderColor: CGColor(red: 122/255, green: 108/255, blue: 97/255, alpha: 1),
        backOfCardColor: UIColor(red: 44/255, green: 80/255, blue: 107/255, alpha: 1)
    )
    
    /**A Collection of all the themes*/
    static var allThemes = [vehiclesTheme, plansTheme, facesTheme,foodTheme, sportTheme, animalsTheme]
    
    //MARK: - End of Theme Struct
}
