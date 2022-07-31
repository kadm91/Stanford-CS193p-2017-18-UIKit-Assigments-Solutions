//
//  SetCardView.swift
//  Consentration-And-Animated-Set-Games
//
//  Created by Kevin Martinez on 5/29/22.
//

import UIKit

/** Draws the simbol, number of symbols, color and shade in each setCardView inside the GridViewContainerForSetCards array in the GridView  */
class SetCardView: UIView,  UIGestureRecognizerDelegate {
    
    //MARK: - Properties
    
    /** The representation of the symbol in the SetCardView  */
    var symbol: String? = shapeOptions.oval.rawValue {didSet {setNeedsDisplay(); setNeedsLayout()}}
    /** The representation of the number of symbols in the SetCardView  */
    var number: Int = 3 {didSet {setNeedsDisplay(); setNeedsLayout()}}
    /** The representation of the symbol color in the SetCardView  */
    var color: UIColor = .green {didSet {setNeedsDisplay(); setNeedsLayout()}}
    /** The representation of the symbol shade in the SetCardView  */
    var shade: String? = shadeOptions.lines.rawValue {didSet {setNeedsDisplay(); setNeedsLayout()}}
    /** Represent if a card is select or not  */
    var isSelected: Bool = false {didSet {setNeedsDisplay(); setNeedsLayout()}}
    /**Represent if the card is face up or face down*/
    var isFaceUP: Bool = false {didSet {setNeedsDisplay(); setNeedsLayout()}}
    
    /** The symbols of the card  */
    enum shapeOptions: String {
        case squiggle
        case oval
        case diamon
    }
    
    /** The shades of the card  */
    enum shadeOptions: String {
        case empty
        case fill
        case lines
    }
    
    /** The hight of the symbol in the SetCardView  */
    private var shapeHeight: CGFloat {
        return bounds.size.height / 4.5
        
    }
    
    /** The width of the symbol in the SetCardView  */
    private var shapeWidth: CGFloat {
        return bounds.size.width / 1.5
    }
    
    /** The center point of the symbol in the SetCardView  */
    private var centerpoint: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    /** The corner radious of SetCardView  */
    private var cornerRadious:CGFloat {
        bounds.size.height * 0.06
    }
    
    //MARK: - draw
    
    override func draw(_ rect: CGRect) {
        
        if self.isFaceUP {
            viewRoundedCorners()
            drawSymbol()
            addShadowsToViewIfSelected()
        } else {
            guard let cardBack = UIImage(named: "SetCardBack") else {return}
            cardBack.draw(in: bounds)
        }
        
    }
    
    //MARK: - traitCollectionDidChange
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setNeedsDisplay()
        setNeedsLayout()
    }
    
    //MARK: - Methods
    
    /** Creates the green shadows around the SetCardView when the isSelected property is true.  */
    private func addShadowsToViewIfSelected(){
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = cornerRadious
        self.layer.shadowColor = UIColor.green.cgColor
        
        switch isSelected {
        case true: self.layer.shadowOpacity = 1
        case false: self.layer.shadowOpacity = 0
            
        }
    }
    
    /** Creates the rounded corners of the SetCardView to give it a card feeling.  */
    private func viewRoundedCorners() {
        
        let roundedCornerRect = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadious)
        roundedCornerRect.addClip()
        UIColor.white.setFill()
        roundedCornerRect.fill()
    }
    
    /** Draws the symbols , number of symbol, color of symbol and shade of the symbol in the SetCardView.  */
    private func drawSymbol(){
        
        if let context = UIGraphicsGetCurrentContext() {
            
            let symbolPossition = drawingPositionForNumberOfSymbols()
            for point in symbolPossition {
                context.saveGState()
                switch symbol {
                case shapeOptions.squiggle.rawValue: drawSquiggleShape(at: point)
                case shapeOptions.diamon.rawValue: drawDiamonShape(at: point)
                case shapeOptions.oval.rawValue: drawOvalShape(at: point)
                default: break
                }
                context.restoreGState()
            }
        } else {
            print("Context was found Nil")
        }
        
    }
    
    /** The position of the drawing symbols in the SetCardView.
     - returns: The CGPoint of where each symbol will be draw in the SetCardView.
     */
    private func drawingPositionForNumberOfSymbols() -> [CGPoint] {
        var possitionPoints = [CGPoint]()
        
        switch number {
        case 1:
            possitionPoints += [centerpoint]
            
        case 2:
            let topPoint = centerpoint.offsetBy(dx: 0, dy: -(shapeHeight / 1.5))
            let bottomPoint = centerpoint.offsetBy(dx: 0, dy: +(shapeHeight / 1.5))
            possitionPoints += [topPoint, bottomPoint]
            
        case 3:
            let topPoint =  centerpoint.offsetBy(dx: 0, dy: (shapeHeight * 2.5) / 2 )
            let bottomPoint = centerpoint.offsetBy(dx: 0, dy: -(shapeHeight * 2.5)/2)
            possitionPoints += [topPoint, centerpoint, bottomPoint]
        default:break
        }
        
        return possitionPoints
        
    }
    
    
    /** Draws the squiggle shape in the SetCardView.
     - parameters:
     - at: the point where the shape will be draw in the SetCardView, this point is calculated using the drawingPositionForNumberOfSymbol to calculate the positon of each symbol in the view if there is more than one symbol to by draw.
     */
    private func drawSquiggleShape(at point: CGPoint) {
        
        let shapePath  = UIBezierPath()
        let distanceToCenter = (shapeWidth / 2 - shapeHeight / 2)
        let upperLeftCenter = point.offsetBy(dx: -distanceToCenter, dy: 0)
        let lowerRightCenter = point.offsetBy(dx: distanceToCenter, dy: 0)
        let unitX = shapeWidth / 8  // breaking down shape width into discrete units
        let unitY = shapeHeight / 4 // breaking down shape height into discrete units
        
        // upper left
        shapePath.move(to: point.offsetBy(dx: -shapeWidth / 2, dy: 0))
        shapePath.addArc(withCenter: upperLeftCenter, radius: shapeHeight / 2, startAngle: CGFloat.pi, endAngle: 3 * CGFloat.pi / 2, clockwise: true)
        
        // top middle
        var curveControlPoint1 = point.offsetBy(dx: 0, dy: -shapeHeight / 2)
        var curveControlPoint2 = point.offsetBy(dx: 0, dy: unitY)
        var endPoint = point.offsetBy(dx: 2 * unitX, dy: -unitY)
        shapePath.addCurve(to: endPoint, controlPoint1: curveControlPoint1, controlPoint2: curveControlPoint2)
        
        curveControlPoint1 = point.offsetBy(dx: 2.5 * unitX, dy: -1.5 * unitY)
        curveControlPoint2 = point.offsetBy(dx: 2.5 * unitX, dy: -2 * unitY)
        endPoint = point.offsetBy(dx: 3 * unitX, dy: -2 * unitY)
        shapePath.addCurve(to: endPoint, controlPoint1: curveControlPoint1, controlPoint2: curveControlPoint2)
        
        // upper right
        curveControlPoint1 = point.offsetBy(dx: 3.5 * unitX, dy: -2 * unitY)
        curveControlPoint2 = point.offsetBy(dx: 4 * unitX, dy:  -unitY)
        endPoint = point.offsetBy(dx: shapeWidth / 2, dy: 0)
        shapePath.addCurve(to: endPoint, controlPoint1: curveControlPoint1, controlPoint2: curveControlPoint2)
        
        // lower right (symmetric to upper left)
        shapePath.addArc(withCenter: lowerRightCenter, radius: shapeHeight / 2, startAngle: 0, endAngle: CGFloat.pi / 2, clockwise: true)
        
        // lower middle
        curveControlPoint1 = point.offsetBy(dx: 0, dy: shapeHeight/2)
        curveControlPoint2 = point.offsetBy(dx: 0, dy: -unitY)
        endPoint = point.offsetBy(dx: -2 * unitX, dy: unitY)
        shapePath.addCurve(to: endPoint, controlPoint1: curveControlPoint1, controlPoint2: curveControlPoint2)
        
        curveControlPoint1 = point.offsetBy(dx: -2.5 * unitX, dy: 1.5 * unitY)
        curveControlPoint2 = point.offsetBy(dx: -2.5 * unitX, dy: 2 * unitY)
        endPoint = point.offsetBy(dx: -3 * unitX, dy: 2 * unitY)
        shapePath.addCurve(to: endPoint, controlPoint1: curveControlPoint1, controlPoint2: curveControlPoint2)
        
        // lower left (symmertric to upper right)
        curveControlPoint1 = point.offsetBy(dx: -3.5 * unitX, dy: 2 * unitY)
        curveControlPoint2 = point.offsetBy(dx: -4 * unitX, dy: unitY)
        endPoint = point.offsetBy(dx: -shapeWidth / 2, dy: 0)
        shapePath.addCurve(to: endPoint, controlPoint1: curveControlPoint1, controlPoint2: curveControlPoint2)
        
        color.setStroke()
        shapePath.lineWidth = 2
        drawShape(at: point, forShapePaht: shapePath)
        shapePath.stroke()
    }
    
    /** Draws the diamon shape in the SetCardView.
     - parameters:
     - at: the point where the shape will be draw in the SetCardView, this point is calculated using the drawingPositionForNumberOfSymbol to calculate the positon of each symbol in the view if there is more than one symbol to by draw.
     */
    private func drawDiamonShape(at poitn: CGPoint){
        let shapePath = UIBezierPath()
        let upperLeftLineOfDiamond = poitn.offsetBy(dx: 0, dy: -shapeHeight/2)
        let upperRightLineOfDiamond = poitn.offsetBy(dx: shapeWidth/2, dy: 0)
        let lowerRightLineOfDiamond = poitn.offsetBy(dx: 0, dy: shapeHeight/2)
        let lowerLeftLineOfDiamond = poitn.offsetBy(dx: -shapeWidth/2, dy: 0)
        
        shapePath.move(to: poitn.offsetBy(dx: -shapeWidth/2, dy: 0))
        shapePath.addLine(to: upperLeftLineOfDiamond)
        shapePath.addLine(to: upperRightLineOfDiamond)
        shapePath.addLine(to: lowerRightLineOfDiamond)
        shapePath.addLine(to: lowerLeftLineOfDiamond)
        
        color.setStroke()
        shapePath.lineWidth = 2
        drawShape(at: poitn, forShapePaht: shapePath)
        shapePath.stroke()
    }
    
    /** Draws the Oval shape in the SetCardView.
     - parameters:
     - at: the point where the shape will be draw in the SetCardView, this point is calculated using the drawingPositionForNumberOfSymbol to calculate the positon of each symbol in the view if there is more than one symbol to by draw.
     */
    private func drawOvalShape(at point: CGPoint) {
        let shapePath =  UIBezierPath()
        let center = shapeWidth/2 - shapeHeight/2
        let leftCenter = point.offsetBy(dx: -center, dy: 0)
        let righCenter = point.offsetBy(dx: center, dy: 0)
        let upperLine = point.offsetBy(dx: center, dy: -shapeHeight/2)
        let lowerLine = point.offsetBy(dx: -center, dy: shapeHeight/2)
        
        
        //left part of oval
        shapePath.addArc(withCenter: leftCenter , radius: shapeHeight/2, startAngle: CGFloat.pi/2, endAngle: 3 * CGFloat.pi / 2, clockwise: true)
        
        // uper line
        shapePath.addLine(to:upperLine)
        
        //right part of oval
        shapePath.addArc(withCenter: righCenter, radius: -shapeHeight/2, startAngle: CGFloat.pi/2, endAngle: 3*CGFloat.pi/2, clockwise: true)
        
        //lower line
        shapePath.addLine(to: lowerLine)
        
        color.setStroke()
        shapePath.lineWidth = 2
        drawShape(at: point, forShapePaht: shapePath)
        shapePath.stroke()
        
        
        
    }
    
    /** Draws the draws the lines in the symbol in case this symbol shade's is lines.
     - parameters:
     - at: The point where this lines where will draw inside the shape.
     */
    private func drawStripsInsideShape(at poitn: CGPoint) {
        let shapePath = UIBezierPath()
        let beginingPoint = poitn.offsetBy(dx: -shapeWidth/2, dy: shapeHeight/2)
        let numberOflines = 24.0
        let spaceBetweenLines = shapeWidth / numberOflines
        var offetLinesBy: CGFloat = 0
        var lineCounter = 0
        shapePath.move(to: beginingPoint)
        while lineCounter < Int(numberOflines) {
            shapePath.addLine(to: shapePath.currentPoint.offsetBy(dx: 0, dy: -shapeHeight))
            offetLinesBy += spaceBetweenLines
            shapePath.move(to: beginingPoint.offsetBy(dx: offetLinesBy, dy: 0))
            lineCounter += 1
        }
        shapePath.lineWidth = 0.5
        color.setStroke()
        shapePath.stroke()
    }
    
    /** Draws the symbol, color, number of symbols and shade of each card in the deck.
     - parameters:
     - at: The point where each symbol will be draw.
     - forShapePath: the symbol this function will draw (squiggles, diamons, ovals)
     */
    private func drawShape (at point: CGPoint, forShapePaht: UIBezierPath) {
        forShapePaht.addClip()
        switch shade {
        case shadeOptions.lines.rawValue: drawStripsInsideShape(at: point)
        case shadeOptions.fill.rawValue: color.setFill() ;forShapePaht.fill()
        default: break
        }
    }
    
    //MARK: - End of SetCardView
}

//MARK: - Extensions

extension CGPoint {
    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        return CGPoint(x: x+dx, y: y+dy)
    }
}
