//
//  ViewController.swift
//  Memorization-Game
//
//  Created by Kevin Martinez on 4/2/22.
//

import UIKit

class MemorizationViewController: UIViewController {
    
    //MARK: - IBOutles
    
    @IBOutlet private var cardButtons: [UIButton]!
    @IBOutlet private var themeButtoms: [UIButton]!
    
    @IBOutlet private weak var themeTitleLabel: UILabel!
    @IBOutlet private weak var flipCountLabel: UILabel!
    @IBOutlet private weak var scoreLabel: UILabel!
    
    
    //MARK: -  Properties
    
    private lazy var memorizationGameBrain =  MemorizationBrain(numberOfPairsOFCards: pairsOfCars)
    private var theme = Themes.themes[Int.random(in: 0..<Themes.themes.count)]
    
    private lazy var themeProperties = (name: theme.name,
                                        BackgrounColor: theme.backGroundColor,
                                        cardColor: theme.backOfCardColor,
                                        cardBorderColor:  theme.borderOfCardColor,
                                        themeBtnsBackgroundColor: theme.themeButtomBackground,
                                        emojiesChoices: theme.emoji)
    
    private var emoji = [Card:String]()
    
    //MARK: - Computed properties
    
    private var pairsOfCars: Int {
        (cardButtons.count + 1) / 2
    }
    //MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            self.themeTitleLabel.text =  self.themeProperties.name
            self.view.backgroundColor =  self.themeProperties.BackgrounColor
            self.cardsDesign()
            self.themeButtomsDesign()
        }
    }
    
    //MARK: - IBActions
    
    @IBAction private func touchCard(_ sender: UIButton) {
        
        if let selectedCard = cardButtons.firstIndex(of: sender) {
            memorizationGameBrain.selectedCard(at: selectedCard)
            DispatchQueue.main.async {
                self.updateUiFromGameBrain()
            }
        } else {
            print("chosen card was not in the cardButtoms array")
        }
    }
    
    @IBAction private func newGame(_ sender: Any) {
        selectedtheme(from: Int.random(in: 0..<Themes.themes.count))
    }
    
    @IBAction private func selectedTheme(_ sender: UIButton) {
        
        guard let themePressed = themeButtoms.firstIndex(of: sender) else {return}
        selectedtheme(from: themePressed)
    }
    
    //MARK: - Methods
    
    // uptates the UI from the game model
    private func updateUiFromGameBrain(){
        
        for index in memorizationGameBrain.cards.indices{
            let button = cardButtons[index]
            let card = memorizationGameBrain.cards[index]
            
            switch card.isFaceUp {
                
            case true:
                button.setTitle(addEmojisToCards(for: card), for: .normal)
                button.backgroundColor = .systemGray5
                button.layer.borderColor = themeProperties.cardBorderColor
                flipCountLabel.text = "Flips: \(memorizationGameBrain.flipCount)"
                scoreLabel.text = "Score: \(memorizationGameBrain.Score)"
                
            case false:
                button.setTitle("", for: .normal)
                button.backgroundColor = card.isMatch ? .clear : themeProperties.cardColor
                button.layer.borderColor = card.isMatch ? UIColor.clear.cgColor : themeProperties.cardBorderColor
                button.isEnabled = card.isMatch ? false : true
            }
        }
    }
    
    // add the emojies to the card by the card's id
    private func addEmojisToCards(for card: Card) -> String {
        
        if emoji[card] == nil, themeProperties.emojiesChoices.count > 0 {
            emoji[card] = themeProperties.emojiesChoices.remove(at: Int.random(in: 0..<themeProperties.emojiesChoices.count))
        }
        return emoji[card] ?? "?"
    }
    
    //TODO: combine cardDesign and themeButtomsDesign properties into one and add parameters/Arguments to use inside the new game function and the theme selection to reduce code!!!
    
    // disigned the card when launching the app depending of the random theme
    private func cardsDesign() {
        
        for button  in cardButtons {
            
            button.titleLabel?.font = .systemFont(ofSize: 35)
            button.layer.cornerRadius = 15
            button.layer.borderWidth = 4
            button.layer.borderColor = themeProperties.cardBorderColor
            button.backgroundColor = themeProperties.cardColor
        }
    }
    
    // dising the selection theme buttoms when app starts
    private func themeButtomsDesign(){
        
        for index in themeButtoms.indices {
            
                self.themeButtoms[index].bounds.size.width = 50
                var heigh = self.themeButtoms[index].bounds.size.height
                heigh = 50
                
                self.themeButtoms[index].layer.cornerRadius =  0.5 * heigh
                self.themeButtoms[index].clipsToBounds = true
                self.themeButtoms[index].backgroundColor = self.themeProperties.themeBtnsBackgroundColor
        }
    }
    
    //TODO: change the theme of the game and restarted to a new game. // think to a better name because this function is also use to start a random new game
    private func selectedtheme(from theme: Int) {
        
        if theme >= Themes.themes.startIndex && theme < Themes.themes.endIndex {
            DispatchQueue.main.async {
                
                self.memorizationGameBrain = MemorizationBrain(numberOfPairsOFCards: self.pairsOfCars)
                self.emoji = [:]
                self.flipCountLabel.text = "Flips: 0"
                self.scoreLabel.text = "Score: 0"
                
                let theme = Themes.themes[theme]
                
                self.themeProperties.emojiesChoices = theme.emoji
                self.view.backgroundColor = theme.backGroundColor
                self.themeTitleLabel.text = theme.name
                
                self.themeProperties.BackgrounColor =  theme.backGroundColor
                self.themeProperties.cardColor = theme.backOfCardColor
                self.themeProperties.cardBorderColor = theme.borderOfCardColor
                self.themeProperties.themeBtnsBackgroundColor = theme.themeButtomBackground
                
                for card in self.cardButtons {
                    
                    card.layer.borderColor = self.themeProperties.cardBorderColor
                    card.backgroundColor = self.themeProperties.cardColor
                    card.setTitle(" ", for: .normal)
                    card.isEnabled = true
                }
                
                for themeButtom in self.themeButtoms {
                    themeButtom.backgroundColor = self.themeProperties.themeBtnsBackgroundColor
                }
            }
        } else {
            
            print("index out of range")
        }
    }
    //MARK: - End of MemorizationViewController
}



