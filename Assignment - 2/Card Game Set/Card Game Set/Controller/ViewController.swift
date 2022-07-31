//
//  ViewController.swift
//  Card Game Set
//
//  Created by Kevin Martinez on 4/15/22.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: -  IBOutlets
    @IBOutlet private weak var deal3CardOutlet: UIButton!
    
    @IBOutlet private var cardButtons: [UIButton]! {
        didSet {
            prepareUIfromModel()
            for card in 12..<cardButtons.count{
                cardButtons[card].isHidden = true
            }
        }
    }
    
    @IBOutlet weak private var score: UILabel! {
        didSet {
            score.text = "Score: 0"
        }
    }
    
    @IBOutlet weak var persentageCompleted: UILabel! {
        didSet {
            persentageCompleted.text = "0%"
        }
    }
    
    
    
    //MARK: - properties
    
    
    lazy private var GameBrain = setGameBrain()
    lazy private var visibleCards = 12
    
    //MARK: - Computed Properties
    
    private var numberOfCards: Int {
        (cardButtons.count + 1) / 2
    }
    
    //MARK: - IBActions
    
    @IBAction private func cardSelectedAction(_ sender: UIButton) {
        
        if let selectedCardNumber = cardButtons.firstIndex(of: sender){
            GameBrain.selectedCardFunction(at: selectedCardNumber)
            UpdateUIFromModel()
            
        } else {
            print("Selected card is not in button array")
        }
    }
    
    @IBAction private func deal3MoreCards(_ sender: UIButton) {
        
        if GameBrain.deck.deck.count >= 3 && GameBrain.gameCards.count == 24 {
            if GameBrain.matchesCardButtonIndeces.isEmpty {
                if visibleCards < cardButtons.count  {
                    for _ in 0...2 {
                        cardButtons[visibleCards].isHidden = false
                        visibleCards += 1
                    }
                }
            } else {
                
                GameBrain.dealCards()
                
                for index in GameBrain.matchesCardButtonIndeces {
                    
                    let card = GameBrain.gameCards[index]
                    let  button = cardButtons[index]
                    let attributeText = cardConfiguration(card: card )
                    
                    button.setAttributedTitle(attributeText, for: .normal)
                    button.backgroundColor = .white
                    button.isEnabled = true
                }
                GameBrain.matchesCardButtonIndeces = []
            }
        } else {
            sender.isEnabled = false
            for index in GameBrain.matchesCardButtonIndeces {
                let buttom = cardButtons[index]
                buttom.isEnabled = false
            }
        }
    }
    
    @IBAction private func newGame(_ sender: UIButton) {
        newGame()
    }
    
    //MARK: - Methods
    
    private func updateScoreAndcompletedPercentage(){
        persentageCompleted.text = "\(Int(GameBrain.persentageCompleted))%"
        score.text = "Score: \(GameBrain.score)"
    }
    
    private func UpdateUIFromModel(){
        
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = GameBrain.gameCards[index]
            if !card.isMatch {
                updateScoreAndcompletedPercentage()
                button.backgroundColor = .white
            }
            if card.selectedCar {
                button.layer.borderWidth =  5
                button.layer.borderColor = UIColor.green.cgColor
                
            } else {
                button.layer.borderWidth = 0
                
            }
            
            if card.isMatch && GameBrain.deck.deck.count == 0 {
                updateScoreAndcompletedPercentage()
                let attibuteString = NSAttributedString(string: " ", attributes: nil)
                button.setAttributedTitle(attibuteString, for: .normal)
                button.backgroundColor = .clear
            }
            
            if card.isMatch  {
                updateScoreAndcompletedPercentage()
                button.isEnabled = false
                button.backgroundColor = .systemGray4
                button.layer.borderWidth = 0
            }
            
        }
    }
    
    private func prepareUIfromModel(){
        
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = GameBrain.gameCards[index]
            let attributeText = cardConfiguration(card: card)
            button.setAttributedTitle(attributeText, for: .normal)
            button.backgroundColor = .white
            
        }
    }
    
    private func cardConfiguration(card: Card) ->  NSAttributedString{
        
        var symbol = String()
        var symbolColor = UIColor()
        var shadding = CGFloat()
        var alpha = CGFloat()
        var cardSymbol = ""
        
        switch  card.symbol  {
        case .oval: cardSymbol = "●"
        case .square: cardSymbol = "■"
        case .triangle: cardSymbol = "▲"
        }
        
        switch card.numberOfSymbols {
        case .one: symbol = cardSymbol
        case .two: symbol =  cardSymbol + " " + cardSymbol
        case .three: symbol =  cardSymbol + " " + cardSymbol + " " + cardSymbol
        }
        
        switch card.symbolColor {
        case .green: symbolColor = .green
        case .red: symbolColor = .red
        case .blue: symbolColor = .blue
        }
        
        switch card.shading {
        case .solid: shadding = 0 ; alpha = 1
        case .empty: shadding = 5
        case .strips: shadding = 0 ; alpha = 0.25
        }
        
        let attributes:[NSAttributedString.Key : Any] = [
            .strokeWidth: shadding,
            .strokeColor: symbolColor,
            .foregroundColor: UIColor.withAlphaComponent(symbolColor)(alpha)
        ]
        
        let attibuteString = NSAttributedString(string: symbol, attributes: attributes)
        return attibuteString
    }
    
    private func newGame() {
        
        for card in 12..<cardButtons.count{
            cardButtons[card].isHidden = true
        }
        
        for index in cardButtons.indices {
            cardButtons[index].isEnabled = true
            //            cardButtons[index].isHidden = false
        }
        
        GameBrain = setGameBrain()
        updateScoreAndcompletedPercentage()
        prepareUIfromModel()
        UpdateUIFromModel()
        deal3CardOutlet.isEnabled = true
        visibleCards =  12
    }
    
    //MARK: - end of vc
}
