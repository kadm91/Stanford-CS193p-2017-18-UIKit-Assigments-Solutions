//
//  GridViewContainerForSetCards.swift
//  Consentration-And-Animated-Set-Games
//
//  Created by Kevin Martinez on 5/29/22.
//

/**
 Use to tranfer the functionality of the tapGesture to the viewController
 */
protocol HandleSelectedCardDelegate {
    func handleTapedCard(with cardIndex: Int)
}

import UIKit

/**
 Alocate the SetCardViews in the a grid created with the Grid Object into colums and rows.
 */
class GridViewContainerForSetCards: UIView, UIGestureRecognizerDelegate {
    
    //MARK: - Properties
    
    /** Array of the SetCardViews to be use in game. */
    var currentCards = [SetCardView]() {didSet {setNeedsLayout(); setNeedsDisplay()}}
    
    /** Delegate propertie of the HandleTapedCard protocol. */
    var tapCardDelegate: HandleSelectedCardDelegate?
    
    /**The size of the card in the deck*/
    var intialCardSizeOnDeck: CGSize? {didSet {setNeedsLayout(); setNeedsDisplay()}}
    
    /**The initial origin of the card as per Deck postion*/
    var initialCardOriginFromDeck: CGPoint? {didSet {setNeedsLayout(); setNeedsDisplay()}}
    
    //MARK: - layoutSubviews
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutCards()
    }
    
    //MARK: - Methods
    
    /** Layout the SetCardViews insede the grid view in order to aligned them by columns and rowns and resize them depending of the number of SetCardViews in the currentCards views array. */
    private func layoutCards() {
        
        var grid = Grid(layout: .aspectRatio(K.aspectRatio))
        grid.frame.size = self.frame.size
        grid.cellCount = currentCards.count
        
        let cardWitdh = grid.cellSize.width - K.spaceBetweenCards
        let cardHeight = grid.cellSize.height - K.spaceBetweenCards
        var i = 0
        
        // move the cards that in the UI to a new postion in the UI to make space for the new cards
        for card in currentCards {
            if subviews.contains(card){
                card.frame.size = CGSize(
                    width: cardWitdh,
                    height: cardHeight
                )
                if card.frame.origin != CGPoint(x: (grid[i]?.origin.x)!,y: (grid[i]?.origin.y)!){
                    animateCardObject(
                        for: card,
                        MoveTo: CGPoint(x: (grid[i]?.origin.x)!, y: (grid[i]?.origin.y)!),
                        width: cardWitdh,
                        height: cardHeight)
                }
                card.tag = currentCards.firstIndex(of: card)!
                card.isOpaque = false
                i += 1
            }
        }
        
        
        
        
        // Move the cards from the deck origin to their corresponded cell in the begining of the game and when new cards are deal
        var dealDelayperCard = K.Animation.dealCardDelay
        for card in currentCards {
            
            if !subviews.contains(card) {
                
                let moveToContainer = CGPoint(x: (grid[i]?.origin.x)! , y: (grid[i]?.origin.y)! )
                guard let initialCardOriginFromDeck = initialCardOriginFromDeck else { print("Origin isn't be pass") ;return}
                
                guard let intialCardSizeOnDeck = intialCardSizeOnDeck else { print("Size isn't be pass") ;return}
                
                // add the card view to the deck pile
                card.frame.size = CGSize(width: intialCardSizeOnDeck.width , height: intialCardSizeOnDeck.height)
                card.frame.origin = initialCardOriginFromDeck
                card.isOpaque =  false
                card.tag = currentCards.firstIndex(of: card)!
                card.isFaceUP = false
                addSubview(card)
                
                // add UITapGestureRecognizer
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOnCard))
                tapGesture.delegate = self
                card.addGestureRecognizer(tapGesture)
                
                
                // add the card animation
                dealNewCardsAnimations(
                    for: card,
                    isFaceUP: true,
                    MoveTo: moveToContainer,
                    width: cardWitdh,
                    height: cardHeight,
                    duration: K.Animation.flipCardDuration,
                    delay: dealDelayperCard
                )
                
                i += 1
                dealDelayperCard += K.Animation.dealCardDelay
                
            }
        }
        
    }
    
    //MARK: - Animation Methods
    
    
    /**
     Use to move cards that are already in the UI.

     - Parameters:
        - for: The View that will recieve the animation.
        - moveTo: The point in the UI where the view will move to.
        - width: The view's new width.
        - height: The view's new height.
        - duration: The animation duration, in secounds. this parameter is optional. If no value is assigns 0 will be assigned as its value what make animation instantanius
        - delay: The time before the animation starts. in secounds.this parameter is optional. If no value is assigns 0 will be assigned as its value what make animation instantanius
     */
    private func animateCardObject(for card: SetCardView, MoveTo: CGPoint, width: CGFloat, height: CGFloat, duration: Double = 0, delay: Double = 0) {
        
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: duration,
            delay: delay,
            animations: {
                card.frame.origin = MoveTo
                card.frame.size = CGSize(width: width, height: height)
            })
    }
    
    
  
    /**
     Used for dealing the begining cards of the game as well to deal three more cards with gesture, touching the deck view or when there is less than 12 cards in the UI.

     - Parameters:
        - for: The View that will recieve the animation.
        - moveTo: The point in the UI where the view will move to.
        - width: The view's new width.
        - height: The view's new height.
        - duration: The animation duration, in secounds.
        - delay: The time before the animation starts. in secounds.
     */
    func dealNewCardsAnimations(for card: SetCardView, isFaceUP: Bool ,MoveTo point: CGPoint, width: CGFloat, height: CGFloat, duration: Double, delay: Double, completion: ((UIViewAnimatingPosition) -> Void)? = nil)  {
        
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: duration,
            delay: delay,
            options: [],
            animations: {
                card.frame.origin = point
                card.frame.size = CGSize(width: width, height: height)
            },
            completion: { finished in
                UIView.transition(
                    with: card,
                    duration: K.Animation.flipCardDuration,
                    options: .transitionFlipFromLeft,
                    animations: {card.isFaceUP = isFaceUP})
                UIViewPropertyAnimator.runningPropertyAnimator(
                    withDuration: 0,
                    delay: 0,
                    options: [],
                    animations: {},
                    completion: completion)
                
            })
        
        
        
    }
    
    
    //MARK: - @objc methods
    
    /**
     The selector function for the tapGesture
     - parameters:
     - sender: Takes a UITapGestureRecognizer to perform the selection of the card and get its tag value that is associated with the index of the card in the deck in gameBrainModel.
     */
    @objc private func handleTapOnCard (_ sender: UITapGestureRecognizer){
        
        switch sender.state {
        case .ended:
            
            let recongnized =  sender.view as? SetCardView
            
            guard let tapedCard = recongnized?.tag else {print("indexOfTapedCard was found nil"); return}
            tapCardDelegate?.handleTapedCard(with: tapedCard)
        default: break
        }
        
        
    }
    //MARK: - GridViewContainer constatns
    /**GridViewContainer constants.*/
    private struct K {
        static let spaceBetweenCards:CGFloat = 8
        
        static let aspectRatio:CGFloat = 2.5/3.5
        struct Animation {
            static let flipCardDuration = 0.75
            static let dealCardDuration = 0.4
            static var dealCardDelay = 0.3
            
        }
    }
    //MARK: - End of the GRidViewContainer
    
}
