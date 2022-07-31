//
//  ViewController.swift
//  Graphical-Set-Game
//
//  Created by Kevin Martinez on 5/4/22.
//


import UIKit

/** The Controller for the Set Card Game, work as  center of communication between the models and the views */
class SetGameViewController: UIViewController {
    //MARK: - Properties
    
    /** Instance of the SetGameBrainModel. */
    var gameBrain = SetGameBrainModel()
    /**Dictionary property to connect each card in the deck with the SetCardView using the index of the card in the deck as the key value.**/
    var gameCardToSetCardView = [Int: SetCardView]()
    //MARK: - IBOutlets
    
    
    @IBOutlet private weak var gridView: GridViewContainerForSetCards! {
        didSet {
            // creating the swipe and rotation UIGestures in the grid
            let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeToDeal3Cards))
            swipeGesture.direction = [.down]
            
            let rotateGesture = UIRotationGestureRecognizer(target: self, action: #selector(rotateToShuffle))
            
            gridView.addGestureRecognizer(swipeGesture)
            gridView.addGestureRecognizer(rotateGesture)
        }
    }
    @IBOutlet private weak var scoreLabel: UILabel!
    @IBOutlet private weak var percentageCompleted: UILabel!
    @IBOutlet private weak var deal3CardsBtn: UIButton!
    
    
    //MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViewFromModel()
        gridView.tapCardDelegate = self
        
    }
    
    //MARK: - @objc functions
    /**
     The selector for the UIGesture add in the griedView outlet to deal 3 more cards when this gesture is detected.
     
     - parameters:
        - sender: the UISwipeGestureReconizer in which we will use its states to code our deal 3 more cards funcionality.
     */
    @objc func swipeToDeal3Cards(_ sender: UISwipeGestureRecognizer){
        
        switch sender.state {
        case .ended:
            if gameBrain.availableCardsOnDeck.count >= 3 {
                gameBrain.deal3MoreCards()
                updateViewFromModel()
            } else {
                deal3CardsBtn.isEnabled = false
                updateViewFromModel()
            }
        default: break
        }
        
        
    }
    
    /**
     The selector for the UIGesture add in the griedView outlet to shuffle the cards when the player gets stuck.
     
     - parameters:
        - sender: the UISwipeGestureReconizer in which we will use its states to code the random cards and return them to the view for the player.
     */
    @objc func rotateToShuffle(_ sender: UIRotationGestureRecognizer) {
        switch sender.state {
        case .ended:
            let currentCardOndisplay =  gridView.currentCards.count
            for cardView in gridView.currentCards {
                cardView.removeFromSuperview()
            }
            
            gridView.currentCards.removeAll()
            gameCardToSetCardView.removeAll()
            gameBrain.reshufleCards(numberOFCardToREshuffle: currentCardOndisplay )
            updateViewFromModel()
            
        default: break
        }
        
    }
    
    //MARK: - @IBActions
    
    
    @IBAction func deal3MoreCards(_ sender: UIButton) {
        
        if gameBrain.availableCardsOnDeck.count >= 3 {
            gameBrain.deal3MoreCards()
            updateViewFromModel()
        } else {
            sender.isEnabled = false
        }
    }
    
    @IBAction func newGame(_ sender: UIBarButtonItem) {
        gameBrain = SetGameBrainModel()
        for cardView in gridView.currentCards {
            cardView.removeFromSuperview()
        }
        gridView.currentCards.removeAll()
        gameCardToSetCardView.removeAll()
        scoreLabel.text = "Score: \(gameBrain.score)"
        percentageCompleted.text = "\(Int(gameBrain.percentageCompleted))%"
        updateViewFromModel()
    }
    
    
    //MARK: - Methods
    
    /** Updates the user interface ( UI ) form the models, this make the view data driving. */
    private func updateViewFromModel() {

        // convert the symbol color from the setCard model to a UIColor representable by the SetCardView
        let symbolColor = [SetCard.SymbolColor.green: UIColor.green, SetCard.SymbolColor.blue: UIColor.blue, SetCard.SymbolColor.red: UIColor.red]

        // convert the numer of symbol in the SetCardModel from a string to an Int
        let numberOfSymbols = [SetCard.NumberOfSymbols.one: 1, SetCard.NumberOfSymbols.two: 2, SetCard.NumberOfSymbols.three: 3]

        // go to all teh cards in cardOnGame array in the SetCardGameBrainModel to convert them in UI view using the SetCardView
        for card in gameBrain.cardOnGame {
            if !gameCardToSetCardView.keys.contains(card) {
                let newCardView = SetCardView()
                newCardView.shade =  gameBrain.deck[card].symbolshadding.rawValue
                newCardView.symbol = gameBrain.deck[card].symbol.rawValue
                newCardView.number =  numberOfSymbols[gameBrain.deck[card].numberOfSymbols]!
                newCardView.color =  symbolColor[gameBrain.deck[card].symbolColor]!
                gameCardToSetCardView[card] = newCardView
                gridView.currentCards += [newCardView]
                newCardView.tag = card
            }
        }
        }
    
    
    //MARK: - End of ViewController
    
    }

//MARK: -  Extensions

// Extencion to handle the tapGesture funcionality to select each card.
extension SetGameViewController: HandleSelectedCardDelegate {
    func handleTapedCard(with card: Int) {
        
        // index of card in currentCard to make his selection == true and start playint
        guard let indexOfCardView = gameCardToSetCardView[card] else {return}
        guard let cardViewSelected = gridView.currentCards.firstIndex(of:indexOfCardView) else {return}
        let selectedViewCard =  gridView.currentCards[cardViewSelected]
        let itMatches = gameBrain.selectedCardsEvaluation(on: card)
        
        selectedViewCard.isSelected = !selectedViewCard.isSelected
        switch itMatches {
        case true:
            for card in gameBrain.selectedCards {
                guard let indexOfCardView = gameCardToSetCardView[card] else {return}
                if let cardViewIndexinCurrentCardsViews = gridView.currentCards.firstIndex(of: indexOfCardView) {
                    let matchedCardView = gridView.currentCards[cardViewIndexinCurrentCardsViews]
                    matchedCardView.removeFromSuperview()
                    gridView.currentCards.remove(at: cardViewIndexinCurrentCardsViews)
                    gameCardToSetCardView.removeValue(forKey: card)
                }
            }
            scoreLabel.text = "Score: \(gameBrain.score)"
            percentageCompleted.text = "\(Int(gameBrain.percentageCompleted))%"
            
            gameBrain.selectedCards.removeAll()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.50) { [weak self] in
                guard let self = self else {return}
                if self.gameBrain.availableCardsOnDeck.count >= 3 && self.gridView.currentCards.count < 12 {
                    self.gameBrain.deal3MoreCards()
                    self.updateViewFromModel()
                }
            }
            
        case false:
            scoreLabel.text = "Score: \(gameBrain.score)"
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { [weak self] in
                guard let self = self else {return}
                for cardView in self.gridView.currentCards {
                cardView.isSelected = false
            }
            }
        default: break
        }
    }
}



