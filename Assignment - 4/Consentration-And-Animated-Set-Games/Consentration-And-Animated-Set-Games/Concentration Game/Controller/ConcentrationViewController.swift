//
//  ConcentrationViewController.swift
//  Consentration-And-Animated-Set-Games
//
//  Created by Kevin Martinez on 5/26/22.
// KADM

import UIKit

/**The Controller for the Concentration Game*/
class ConcentrationViewController: UIViewController {
    
    //MARK: - Properties
    
    /**Instans of the ConcentrationGameBrainModel*/
    private lazy var gameBrain = concentrationGameBrain(numberOfPairsOfCards: pairsOfCards )
    /**Instans of the ThemeModel*/
    var theme = Theme.allThemes[Int.random(in: 0..<Theme.allThemes.count)]
    /**Tuple of the ThemeProperties*/
    private lazy var themeProperties = (
        name: theme.name,
        backgroundColor: theme.backgroundColor,
        cardColor: theme.backOfCardColor,
        cardBorderColor: theme.cardborderColor,
        emojiesChoice: theme.emoji
    )
    
    /**Array of the emojies that will be use dependeding of the theme that was choosen*/
    private var emoji = [Card:String]()
    
    //MARK: - Computed Properties
    
    /**The number of pairs of cars depending of the number of UIButtons in the UI**/
    private var pairsOfCards: Int {
        (visibleCardButtons.count + 1) / 2
    }
    
    /**The Card Buttons that are visible in the UI depending of the traitColletion**/
    private var visibleCardButtons: [UIButton]! {
        cardButtons?.filter {!$0.superview!.isHidden}
    }
    
    //MARK: - IBOutles
    
    /**An array of UIButtons that represent the cards in the concentration game UI*/
    @IBOutlet private var cardButtons: [UIButton]!
    /**The UILabel the display the score of the concentration game to the player in the UI */
    @IBOutlet private weak var scoreLabel: UILabel! {
        didSet {
            scoreLabel.text = traitCollection.verticalSizeClass == .compact ? "Score\n\(gameBrain.score)" : "Score: \(gameBrain.score)"
        }
    }
    /**The UILabel that display how many times the player has flip the card buttons in the UI**/
    @IBOutlet private weak var flipsLabel: UILabel! {
        didSet {
            flipsLabel.text = traitCollection.verticalSizeClass == .compact ? "Flips\n\(gameBrain.flipCount)" : "Flips: \(gameBrain.flipCount)"
        }
    }
    
    
    //MARK: - View Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        designedUIByChossenTheme()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateScoreAndFlipLabelsBaseOnUIbyDeviceOrientation()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        designedUIByChossenTheme()
        DispatchQueue.main.async { [weak self] in
            if let self = self {
                self.UpdateUIFromModel()
            }
        }
    }
    //MARK: - IBActions
    
    /**
     The UIButton Action that communicates with ConcentrationGameBrainModel to proces what happen every time the user touch a card in the UI.
     
     - Parameters:
     - sender: The card UIButtom that was touched. It get the index.
     */
    @IBAction private func tocheCard(_ sender: UIButton) {
        if let selectedCard = visibleCardButtons.firstIndex(of: sender) {
            gameBrain.selectedCard(at: selectedCard)
            DispatchQueue.main.async { [weak self] in
                if let self = self {
                    self.UpdateUIFromModel()
                }
                
            }
        } else {
            print("choosen card was not in the visibleCardButtons array")
        }
    }
    
    /**
     Creates a new gane of concentration.
     
     - Parameters:
     - sender: The New Game UIButtom that was touched
     */
    @IBAction private func newGame(_ sender: UIButton) {
        
     newGame()
    }
    
    //MARK: - Methods
    
    /** Updates the UI from the ConcentrationGameBrainModel.*/
    private func UpdateUIFromModel() {
        
        if visibleCardButtons != nil {
            
            for index in visibleCardButtons.indices {
                let button = visibleCardButtons[index]
                let card = gameBrain.cards[index]
                
                switch card.isfaceUP {
                case true:
                    
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else {print("self was found nil in the updateUIFromModel Method"); return}
                        
                        button.setTitle(self.addEmojisToCard(for: card), for: .normal)
                        button.backgroundColor = K.faceUpCardBackgoundColor
                        button.layer.borderColor = self.themeProperties.cardBorderColor
                        self.updateScoreAndFlipLabelsBaseOnUIbyDeviceOrientation()
                    }
                    
                case false:
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else {print("self was found nil in the updateUIFromModel Method"); return}
                        button.setTitle("", for: .normal)
                        button.backgroundColor = card.isMatch ? .clear : self.themeProperties.cardColor
                        button.layer.borderColor = card.isMatch ? UIColor.clear.cgColor : self.themeProperties.cardBorderColor
                        button.isEnabled = card.isMatch ? false : true
                    }
                }
            }
        }
    }
    
    /**
     Add the emojies to the card by the card's Id.
     
     - Parameters:
     - for: The card that with get the emoji
     */
    private func addEmojisToCard(for card: Card) -> String {
        if emoji[card] == nil, themeProperties.emojiesChoice.count > 0 {
            emoji[card] = themeProperties.emojiesChoice.remove(at: Int.random(in: 0..<themeProperties.emojiesChoice.count))
        }
        return emoji[card] ?? "?"
    }
    
    /**Prepares the card buttons UI**/
    private func designedUIByChossenTheme() {
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {print("self was found nil in the designedUIByChossenTheme Method"); return}
            self.view.backgroundColor = self.themeProperties.backgroundColor
            for cardButton in self.cardButtons {
                cardButton.titleLabel?.font = .systemFont(ofSize: K.fontSize)
                cardButton.layer.cornerRadius = K.cardCornerRadius
                cardButton.layer.borderColor = self.themeProperties.cardBorderColor
                cardButton.backgroundColor = self.themeProperties.cardColor
                cardButton.layer.borderWidth = K.cardBorderWith
            }
        }
    }
    
    /**Updates the how the flips and Score label are show in the UI**/
    private func updateScoreAndFlipLabelsBaseOnUIbyDeviceOrientation(){
        flipsLabel.text = traitCollection.verticalSizeClass == .compact ? "Flips\n\(gameBrain.flipCount)" : "Flips: \(gameBrain.flipCount)"
        scoreLabel.text = traitCollection.verticalSizeClass == .compact ? "Score\n\(gameBrain.score)" : "Score: \(gameBrain.score)"
    }
    
    func newGame() {
        gameBrain = concentrationGameBrain(numberOfPairsOfCards: pairsOfCards )
        emoji = [:]
        updateScoreAndFlipLabelsBaseOnUIbyDeviceOrientation()
        theme = Theme.allThemes[Int.random(in: 0..<Theme.allThemes.count)]
        themeProperties.name = theme.name
        themeProperties.backgroundColor = theme.backgroundColor
        themeProperties.cardColor = theme.backOfCardColor
        themeProperties.cardBorderColor = theme.cardborderColor
        themeProperties.emojiesChoice = theme.emoji
        designedUIByChossenTheme()
        UpdateUIFromModel()
    }
    
    
    //MARK: - Constants
    /**Private struc for all the ConcentrationViewController Constanse**/
    private struct K {
        static let fontSize: CGFloat = 35
        static let cardCornerRadius: CGFloat = 15
        static let cardBorderWith: CGFloat = 5
        static let faceUpCardBackgoundColor: UIColor  = .systemGray5
        
    }
    //MARK: - End of the ConcentrationViewController
}
