//
//  ThemesViewController.swift
//  Consentration-And-Animated-Set-Games
//
//  Created by Kevin Martinez on 5/27/22.
//

import UIKit

class ThemesViewController: UIViewController, UISplitViewControllerDelegate {

    
/**Array used to give the chocen theme to the ConcentrationViewController **/
   private let themes: [String:Theme] = [
        K.vehiclesThemeSegue: Theme.vehiclesTheme,
        K.plansThemeSegue: Theme.plansTheme,
        K.facesThemeSegue: Theme.facesTheme,
        K.foodsThemeSegue: Theme.foodTheme,
        K.sportsThemeSegue: Theme.sportTheme,
        K.animalThemeSegue: Theme.animalsTheme,
        K.randomThemeSegue: Theme.allThemes[Int.random(in: 0..<Theme.allThemes.count)]
        
    ]
    
//MARK: - awakeFromNib
    
    override func awakeFromNib() {
        super.awakeFromNib()
        splitViewController?.delegate = self
    }
    
    
 //MARK: - Methods
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
      return true
    }
    
    /**
     Creates a randomTheme.
     
     - Returns: Returns a Random Theme.
     */
    private func randomTheme() -> Theme {
        Theme.allThemes[Int.random(in: 0..<Theme.allThemes.count)]
    }
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if let Choosentheme = themes[identifier] {
                if let concentrationVC = segue.destination as? ConcentrationViewController {
                    if identifier == K.randomThemeSegue {
                        concentrationVC.theme = randomTheme()
                    } else {
                        concentrationVC.theme = Choosentheme
                    }
                }
            }
        }
    }
    

    
    //MARK: - Constants
    
    /**Constants Struck for ThemesViewController**/
    private struct K {
        static let vehiclesThemeSegue = "vehicles"
        static let plansThemeSegue = "plans"
        static let facesThemeSegue = "faces"
        static let foodsThemeSegue = "foods"
        static let sportsThemeSegue = "sports"
        static let animalThemeSegue = "animals"
        static let randomThemeSegue = "random"
    }
    
    
    
    //MARK: - End of ThemesViewController
}
