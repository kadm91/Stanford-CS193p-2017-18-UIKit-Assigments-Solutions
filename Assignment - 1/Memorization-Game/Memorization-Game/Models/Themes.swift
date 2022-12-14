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
        emoji: ["ð", "ð", "ð", "ð", "ð", "ð", "ð", "ð", "ð", "ð", "ðŧ", "ð", "ðĩ", "ð", "ðš", "âïļ"],
        backGroundColor: .darkGray,
        borderOfCardColor: UIColor.black.cgColor,
        backOfCardColor: .systemRed,
        themeButtomBackground: .gray)
    
    private static let plansTheme = Themes(
        name: "Plans",
        emoji: ["ðĩ", "ðē", "ðģ", "ðī", "ðą", "âïļ", "ðŋ", "ðŠī", "ð", "ð", "ðđ", "ðŧ", "ðļ", "ðŠ·", "ðž", "ðū", "ð", "ðš", "ð·", "ð ", "ðĨ ", "ð", "ðŠĩ"],
        backGroundColor: UIColor.systemMint,
        borderOfCardColor: UIColor.systemPurple.cgColor,
        backOfCardColor: UIColor.systemOrange,
        themeButtomBackground: UIColor.systemPurple)
    
    private static let facesTheme = Themes(
        name: "Faces",
        emoji: ["ð", "ðĨđ", "ð", "ðĨē", "ð", "ð§", "ðĪ", "ð", "ðĨļ", "ðĪĐ", "ðĨģ", "ðĪ", "ð­", "ðĪŊ", "ðĄ", "ð·", "ðķâðŦïļ", "ðŦĨ", "ðĪ ", "ðĪ ", "ðĪ ", "ðĩâðŦ", "ðĨķ"], backGroundColor: UIColor.systemIndigo,
        borderOfCardColor: UIColor.systemGray.cgColor,
        backOfCardColor: UIColor.purple,
        themeButtomBackground: UIColor.magenta)
    
    
    private static let foodTheme = Themes(
        name: "Food",
        emoji: ["ð", "ð", "ð", "ðģ", "ðĨ", "ðĨĐ", "ð", "ð", "ð", "ðĨŠ", "ðŪ", "ðŊ", "ðĨ", "ðŋ", "ðĨĄ", "ðĪ", "ðŦ", "ð§", "âïļ", "ð­", "ðĨ", "ð§", "ð"], backGroundColor: UIColor(red: 192/255, green: 216/255,blue: 192/255, alpha: 1),
        borderOfCardColor: UIColor(red: 245/255, green: 238/255, blue: 220/255, alpha: 1).cgColor,
        backOfCardColor: UIColor(red: 236/255, green: 179/255, blue: 144/255, alpha: 1),
        themeButtomBackground: UIColor(red: 221/255, green: 74/255, blue: 72/255, alpha: 1))
    
    
    private static let sportTheme = Themes(name: "Sports", emoji: ["â―ïļ", "ð", "ð", "âūïļ", "ðą", "ð", "ðđ", "ðĨ", "ðđ", "ðĨ", "ðĪŋ", "ðĨ", "ðž", "ð·", "âļ", "ðĨ", "ð", "ðŠ", "ðââïļ", "ðââïļ", "ðĢââïļ", "ðīââïļ", "ðŋ"], backGroundColor: UIColor(red: 26/255, green: 38/255, blue: 91/255, alpha: 1), borderOfCardColor: UIColor(red: 241/255, green: 97/255, blue: 13/255, alpha: 1).cgColor, backOfCardColor: UIColor(red: 80/255, green: 165/255, blue: 175/255, alpha: 1), themeButtomBackground: UIColor(red: 255/255, green: 245/255, blue: 237/255, alpha: 1))
    
    private static let animalsTheme = Themes(name: "Animals", emoji: ["ðķ", "ðą", "ð­", "ðđ", "ð°", "ðĶ", "ðŧ", "ðž", "ðĻ", "ðĶ", "ðŪ", "ð·", "ðļ", "ðĩ", "ð", "ð§", "ðĢ", "ðĶ", "ðĶ", "ð", "ðĶĢ", "ð", "ðĶ"], backGroundColor: UIColor(red: 208/255, green: 118/255, blue: 76/255, alpha: 1), borderOfCardColor: CGColor(red: 122/255, green: 108/255, blue: 97/255, alpha: 1), backOfCardColor: UIColor(red: 44/255, green: 80/255, blue: 107/255, alpha: 1), themeButtomBackground: UIColor(red: 233/255, green: 177/255, blue: 103/255, alpha: 1))
    
    
    static let themes = [vehiclesTheme, plansTheme, facesTheme, foodTheme, sportTheme, animalsTheme]
    
    
    
}
