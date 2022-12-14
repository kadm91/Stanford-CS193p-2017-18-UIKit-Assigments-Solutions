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
        emoji: ["π", "π", "π", "π", "π", "π", "π", "π", "π", "π", "π»", "π", "π΅", "π", "πΊ", "βοΈ"],
        backgroundColor: .darkGray,
        cardborderColor: UIColor.black.cgColor,
        backOfCardColor: .systemRed
    )
    /** A Theme based on plans*/
    private (set) static var plansTheme = ThemesModel(
        name: "Plans",
        emoji: ["π΅", "π²", "π³", "π΄", "π±", "βοΈ", "πΏ", "πͺ΄", "π", "π", "πΉ", "π»", "πΈ", "πͺ·", "πΌ", "πΎ", "π", "πΊ", "π·", "π ", "π₯ ", "π", "πͺ΅"],
        backgroundColor: UIColor.systemMint,
        cardborderColor: UIColor.systemPurple.cgColor,
        backOfCardColor: UIColor.systemOrange
    )
    /** A Theme based on emoji faces*/
    private (set) static var facesTheme = ThemesModel(
        name: "Faces",
        emoji: ["π", "π₯Ή", "π", "π₯²", "π", "π§", "π€", "π", "π₯Έ", "π€©", "π₯³", "π€", "π­", "π€―", "π‘", "π·", "πΆβπ«οΈ", "π«₯", "π€ ", "π€ ", "π€ ", "π΅βπ«", "π₯Ά"],
        backgroundColor: UIColor.systemIndigo,
        cardborderColor: UIColor.systemGray.cgColor,
        backOfCardColor: UIColor.purple
    )
    
    /** A Theme based on food */
    private (set) static var foodTheme = ThemesModel(
        name: "Food",
        emoji: ["π", "π", "π", "π³", "π₯", "π₯©", "π", "π", "π", "π₯ͺ", "π?", "π―", "π₯", "πΏ", "π₯‘", "π€", "π«", "π§", "βοΈ", "π­", "π₯", "π§", "π"],
        backgroundColor: UIColor(red: 192/255, green: 216/255,blue: 192/255, alpha: 1),
        cardborderColor: UIColor(red: 245/255, green: 238/255, blue: 220/255, alpha: 1).cgColor,
        backOfCardColor: UIColor(red: 236/255, green: 179/255, blue: 144/255, alpha: 1)
    )
    
    /** A Theme based on sports*/
    private (set) static var sportTheme = ThemesModel(
        name: "Sports", emoji: ["β½οΈ", "π", "π", "βΎοΈ", "π±", "π", "πΉ", "π₯", "πΉ", "π₯", "π€Ώ", "π₯", "πΌ", "π·", "βΈ", "π₯", "π", "πͺ", "πββοΈ", "πββοΈ", "π£ββοΈ", "π΄ββοΈ", "πΏ"],
        backgroundColor: UIColor(red: 26/255, green: 38/255, blue: 91/255, alpha: 1),
        cardborderColor: UIColor(red: 241/255, green: 97/255, blue: 13/255, alpha: 1).cgColor,
        backOfCardColor: UIColor(red: 80/255, green: 165/255, blue: 175/255, alpha: 1)
    )
    /** A Theme based on animals*/
    private (set) static var animalsTheme = ThemesModel(
        name: "Animals", emoji: ["πΆ", "π±", "π­", "πΉ", "π°", "π¦", "π»", "πΌ", "π¨", "π¦", "π?", "π·", "πΈ", "π΅", "π", "π§", "π£", "π¦", "π¦", "π", "π¦£", "π", "π¦"],
        backgroundColor: UIColor(red: 208/255, green: 118/255, blue: 76/255, alpha: 1),
        cardborderColor: CGColor(red: 122/255, green: 108/255, blue: 97/255, alpha: 1),
        backOfCardColor: UIColor(red: 44/255, green: 80/255, blue: 107/255, alpha: 1)
    )
    
    /**A Collection of all the themes*/
    static var allThemes = [vehiclesTheme, plansTheme, facesTheme,foodTheme, sportTheme, animalsTheme]
    
    //MARK: - End of Theme Struct
}
