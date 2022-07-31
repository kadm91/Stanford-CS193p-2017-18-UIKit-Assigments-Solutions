//
//  ViewController.swift
//  Consentration-And-Animated-Set-Games
//
//  Created by Kevin Martinez on 5/26/22.
//

import UIKit

class SetViewController: UIViewController{
    
    //MARK: - Properties
    
    /** Instance of the SetGameBrainModel. */
    var gameBrain = SetGameBrainModel()
    /**Dictionary property to connect each card in the deck with the SetCardView using the index of the card in the deck as the key value.**/
    var gameCardToSetCardView = [Int: SetCardView]()
    /**The Animator for the animation behaviors*/
    lazy var animator = UIDynamicAnimator(referenceView: gridView)
    lazy var cardBehavior = SetCardBehabior(in: animator)
    
    
    //MARK: - IBOutlets
    
    
    @IBOutlet private weak var gridView: GridViewContainerForSetCards! {
        didSet {
            // creating the swipe and rotation UIGestures in the grid
            let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(deal3Cards))
            swipeGesture.direction = [.down]
            
            let rotateGesture = UIRotationGestureRecognizer(target: self, action: #selector(rotateToShuffle))
            
            gridView.addGestureRecognizer(swipeGesture)
            gridView.addGestureRecognizer(rotateGesture)
        }
    }
    
    @IBOutlet weak var deckView: UIView! {
        didSet{
            let tapGestureInDeckView = UITapGestureRecognizer(target: self, action: #selector(deal3Cards(_:)))
            deckView.addGestureRecognizer(tapGestureInDeckView)
        }
    }
    
    @IBOutlet private weak var scoreLabel: UILabel!
    @IBOutlet private weak var percentageCompleted: UILabel!
    @IBOutlet weak var deckImageView: UIImageView!
    @IBOutlet weak var discardPileView: UIView!
    
    @IBOutlet weak var dealLabel: UILabel!
    @IBOutlet weak var setsLabel: UILabel!
    
    //MARK: - SetViewController life Cicly Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViewFromModel()
        gridView.tapCardDelegate = self
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        deckAndDiscardPileGlobalPositionOnScreen()
        
    }
    
    //MARK: - Style of the status bar
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent
        
    }
    
    //MARK: - @objc functions
    /**
     The selector for the UIGesture add in the griedView outlet to deal 3 more cards when this gesture is detected.
     
     - parameters:
     - sender: the UISwipeGestureReconizer in which we will use its states to code our deal 3 more cards funcionality.
     */
    @objc func deal3Cards(_ sender: UIGestureRecognizer){
        
        switch sender.state {
        case .ended:
            
            if gameBrain.availableCardsOnDeck.count >= 3 {
                gameBrain.deal3MoreCards()
                updateViewFromModel()
            } else {
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
            
            //Animation for shuffle
            
            let currentCardOndisplay =  gridView.currentCards.count
            
            
            var returnDelayperCard = K.animation.shuffleDelay
            
            
            // I did reversed the array so it starts the animation in the last cardView which I personly like more.
            let reversedCurrentCardArray = gridView.currentCards.reversed()
            
            for cardView in reversedCurrentCardArray {
                
                guard let deckPosition = gridView.initialCardOriginFromDeck else {print("No deck Position"); return}
                
                gridView.dealNewCardsAnimations(
                    for: cardView,
                    isFaceUP: false,
                    MoveTo: deckPosition ,
                    width: deckView.bounds.size.width,
                    height: deckView.bounds.size.height,
                    duration: K.animation.shuffleDuration,
                    delay:returnDelayperCard,
                    completion: { finish in
                        cardView.removeFromSuperview()
                    })
                
                returnDelayperCard += K.animation.shuffleDelay
              
            }
            
            gridView.currentCards.removeAll()
            gameCardToSetCardView.removeAll()
            gameBrain.reshufleCards(numberOFCardToREshuffle: currentCardOndisplay )
            
            DispatchQueue.main.asyncAfter(deadline: .now() + returnDelayperCard){ [weak self] in
                guard let self = self else {print("self was found nil in shuffleCard Gesture in SetViewController"); return}
                self.updateViewFromModel()
            }
            
              
 
        default: break
        }
        
    }
    
    //MARK: - @IBActions
    
    
    @IBAction func newGame(_ sender: UIBarButtonItem) {
        gameBrain = SetGameBrainModel()
        
        for cardView in gridView.currentCards {
            cardView.removeFromSuperview()
        }
        
        gridView.currentCards.removeAll()
        gameCardToSetCardView.removeAll()
        UpdateLabels()
        updateViewFromModel()
        
        for card in discardPileView.subviews {
            card.removeFromSuperview()
        }
        
    }
    
    
    //MARK: - Methods
    
    /**The position of the deck and dispcart pile for the animations.*/
    private func deckAndDiscardPileGlobalPositionOnScreen() {
        let deckGlobalPosition = deckView.convert(deckView.bounds.origin, to: gridView)
        gridView.initialCardOriginFromDeck = deckGlobalPosition
        gridView.intialCardSizeOnDeck = deckView.bounds.size
    }
    
    /** Hide the deck when there is no more cards in the deck.*/
    private func hideDeckWhenNoCardsAreAvailable(){
        
        if gameBrain.availableCardsOnDeck.count < 3 {
            DispatchQueue.main.async {[weak self] in
                self?.deckImageView.image = nil
                self?.deckView.isUserInteractionEnabled = false
                self?.dealLabel.textColor = .clear
            }
        } else {
            DispatchQueue.main.async {[weak self] in
                self?.deckImageView.image = UIImage(named: K.backOfCardImage)
                self?.deckView.isUserInteractionEnabled = true
                self?.dealLabel.textColor = .white
            }
        }
    }
    
    
    /** Updates the user interface ( UI ) form the models, this make the view data driving. */
    private func updateViewFromModel() {
        
        hideDeckWhenNoCardsAreAvailable()
        
        // convert the symbol color from the setCard model to a UIColor representable by the SetCardView
        let symbolColor = [
            SetCard.SymbolColor.green: UIColor.green,
            SetCard.SymbolColor.blue: UIColor.blue,
            SetCard.SymbolColor.red: UIColor.red
        ]
        
        // convert the numer of symbol in the SetCardModel from a string to an Int
        let numberOfSymbols = [
            SetCard.NumerOfSymbols.one: 1,
            SetCard.NumerOfSymbols.two: 2,
            SetCard.NumerOfSymbols.three: 3]
        
        // go to all teh cards in cardOnGame array in the SetCardGameBrainModel to convert them in UI view using the SetCardView
        for card in gameBrain.cardOnGame {
            if !gameCardToSetCardView.keys.contains(card) {
                let newCardView = SetCardView()
                newCardView.shade =  gameBrain.deck[card].symbolShadding.rawValue
                newCardView.symbol = gameBrain.deck[card].symbol.rawValue
                newCardView.number =  numberOfSymbols[gameBrain.deck[card].numberOfSymbols]!
                newCardView.color =  symbolColor[gameBrain.deck[card].symbolColor]!
                gameCardToSetCardView[card] = newCardView
                gridView.currentCards += [newCardView]
                
            }
        }
    }
    
    /**Updates the labels of the UI**/
    private func UpdateLabels(){
        DispatchQueue.main.async {[weak self] in
            guard let self = self else {print("self was found nil in UpdateLabel function in viewController"); return}
            self.scoreLabel.text = "Score: \(self.gameBrain.score)"
            self.percentageCompleted.text = "\(Int(self.gameBrain.percentageCompleted))%"
            self.setsLabel.text = "\(self.gameBrain.matchedCards.count / 3) Sets"
        }
    }
    
    //MARK: - End of ViewController
    
}

//MARK: -  Extensions

// Extencion to handle the tapGesture funcionality to select each card.
extension SetViewController: HandleSelectedCardDelegate {
    func handleTapedCard(with cardView: Int) {
        
        let selectedCardView = gridView.currentCards[cardView]
        let cardIndex = gameCardToSetCardView.keysForValues(value: selectedCardView)
        guard let card = cardIndex.first else {return}
        
        //Uncomment to befify that card in screen is the same that card in model
        //        print(gameBrain.deck[card])
        
        selectedCardView.isSelected = !selectedCardView.isSelected
        
        let itMatches = gameBrain.selectedCardsEvaluation(on: card)
        switch itMatches {
        case true:
            
            // evaluate the 3 selected cards to make sure they make a set
            for card in gameBrain.selectedCards {
                
                guard let indexOfCardView = gameCardToSetCardView[card] else {return}
                
                if let cardViewIndexinCurrentCardsViews = gridView.currentCards.firstIndex(of: indexOfCardView) {
                    
                    let matchedCardView = gridView.currentCards[cardViewIndexinCurrentCardsViews]
                    self.gridView.currentCards.remove(at: cardViewIndexinCurrentCardsViews)
                    matchedCardView.isUserInteractionEnabled = false
                    self.cardBehavior.addItem(matchedCardView)
                    self.gridView.bringSubviewToFront(matchedCardView)
                    
                    //Discart matched card Animation and SetCardView Dynamic Behavior
                    DispatchQueue.main.asyncAfter(deadline: .now() + K.animation.behaivorAnimationDuratation) { [weak self] in
                        
                        guard let self = self else {return}
                        self.cardBehavior.removeItem(matchedCardView)
                        
                        UIViewPropertyAnimator.runningPropertyAnimator(
                            withDuration: K.animation.discartMatchCardAnimationDuration,
                            delay: K.animation.discartMatchCardsAnimationDelay,
                            options: [],
                            animations: {
                                matchedCardView.transform = .identity
                                let discartPileGlobalPostion = self.discardPileView.convert(self.discardPileView.bounds.origin, to: self.gridView)
                                matchedCardView.frame.origin = discartPileGlobalPostion
                                
                            },
                            completion: { finish in
                                
                                matchedCardView.isSelected = false
                                matchedCardView.frame.size = self.deckImageView.bounds.size
                                matchedCardView.frame.origin = self.discardPileView.bounds.origin
                                self.discardPileView.addSubview(matchedCardView)
                                self.gameCardToSetCardView.removeValue(forKey: card)
                                
                                if self.gameBrain.availableCardsOnDeck.count >= 3 && self.gridView.currentCards.count < 12 {
                                    self.gameBrain.deal3MoreCards()
                                    self.updateViewFromModel()
                                }
                            }
                        )
                    }
                }
            }
            
            gameBrain.selectedCards.removeAll()
            UpdateLabels()
            
        case false:
            scoreLabel.text = "Score: \(gameBrain.score)"
            DispatchQueue.main.asyncAfter(deadline: .now() + K.animation.deselectionTime) { [weak self] in
                guard let self = self else {return}
                for cardView in self.gridView.currentCards {
                    cardView.isSelected = false
                }
            }
        default: break
        }
    }
    
    //MARK: - SetViewController Constants
    
    private struct K {
        static let backOfCardImage = "SetCardBack"
        struct animation {
            static let deselectionTime = 0.25
            static let behaivorAnimationDuratation = 1.75
            static let discartMatchCardsAnimationDelay = 0.0
            static let discartMatchCardAnimationDuration = 0.5
            static let shuffleDuration = 0.5
            static let shuffleDelay = 0.4
            static let shuffleFlipDuration = 0.75
            
        }
    }
    
    
    //MARK: - End of the extention
}


// https://ijoshsmith.com/2016/04/14/find-keys-by-value-in-swift-dictionary/
extension Dictionary where Value: Equatable {
    func keysForValues(value: Value) -> [Key] {
        return compactMap {(key: Key, val: Value) -> Key? in
            value == val ? key : nil
        }
    }
}


