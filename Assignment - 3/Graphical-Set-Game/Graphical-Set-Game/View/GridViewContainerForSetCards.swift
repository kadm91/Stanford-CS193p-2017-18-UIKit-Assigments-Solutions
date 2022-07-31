//
//  GridViewContainerForSetCards.swift
//  Graphical-Set-Game
//
//  Created by Kevin Martinez on 5/10/22.
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

    /**
     Array of the SetCardViews to be use in game
     */
    var currentCards = [SetCardView]() {didSet {setNeedsLayout(); setNeedsDisplay()}}
    /**
        Delegate propertie of the HandleTapedCard protocol
     */
    var tapCardDelegate: HandleSelectedCardDelegate?
    
    
    
    //MARK: - layoutSubviews
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutCards()

    }
    
    //MARK: - Methods
    
    /**
     Layout the SetCardViews insede the grid view in order to aligned them by columns and rowns and resize them depending of the number of SetCardViews in the currentCards views array.
     */
    private func layoutCards() {
        
        var grid = Grid(layout: .aspectRatio(K.aspectRatio))
        grid.frame.size =  self.frame.size
        grid.cellCount = currentCards.count 
        
        let cardWitdh = grid.cellSize.width - K.spaceBetweenCards
        let cardHeight = grid.cellSize.height - K.spaceBetweenCards
        
        var i = 0
        
        for card in currentCards {
            card.frame.size = CGSize(width: cardWitdh, height: cardHeight)
            card.frame.origin = CGPoint(x: (grid[i]?.origin.x)! , y: (grid[i]?.origin.y)! )
            card.isOpaque =  false
            addSubview(card)
            i += 1
         // add UITapGestureRecognizer
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOnCard))
            tapGesture.delegate = self
            card.addGestureRecognizer(tapGesture)

         
            
        }
    }
    
    /**
        The selector function for the tapGesture
     - parameters:
            - sender: Takes a UITapGestureRecognizer to perform the selection of the card and get its tag value that is associated with the index of the card in the deck in gameBrainModel.
     */
    @objc private func handleTapOnCard (_ sender: UITapGestureRecognizer){
        
        switch sender.state {
        case .ended:
            guard let tapedCard = sender.view?.tag else {print("indexOfTapedCard was found nil"); return}
            tapCardDelegate?.handleTapedCard(with: tapedCard)
        default: break
        }
        
     
    }
    
    
    private struct K {
        static let spaceBetweenCards:CGFloat = 15
        static let aspectRatio:CGFloat = 2.5/3.5
    }
    
}
