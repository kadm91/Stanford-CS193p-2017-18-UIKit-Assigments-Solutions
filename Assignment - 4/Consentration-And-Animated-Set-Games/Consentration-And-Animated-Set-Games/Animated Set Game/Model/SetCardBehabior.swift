//
//  SetCardBehabior.swift
//  Consentration-And-Animated-Set-Games
//
//  Created by Kevin Martinez on 6/3/22.
//

import UIKit

class SetCardBehabior: UIDynamicBehavior {
    
    lazy var collisionBehavior: UICollisionBehavior = {
        let behavior = UICollisionBehavior()
        behavior.translatesReferenceBoundsIntoBoundary = true
        return behavior
    }()
    
    lazy var itemDynamicBehavior: UIDynamicItemBehavior = {
        let behavior = UIDynamicItemBehavior()
        behavior.allowsRotation = true
        behavior.friction = 1.0
        behavior.elasticity = 1.1
        behavior.resistance = -0.1
        return behavior
    }()
    
    
    private func push(_ item: UIDynamicItem) {
        let pushBehavior = UIPushBehavior(items: [item], mode: .instantaneous)
        pushBehavior.angle = (2*CGFloat.pi).arc4random
        pushBehavior.magnitude = CGFloat(7.0) + CGFloat(3.0).arc4random
        pushBehavior.action = { [unowned pushBehavior, weak self] in
            self?.removeChildBehavior(pushBehavior)
        }
        addChildBehavior(pushBehavior)
    }
    
    func addItem(_ item: UIDynamicItem){
        collisionBehavior.addItem(item)
        itemDynamicBehavior.addItem(item)
        push(item)
    }
    
    func removeItem(_ item: UIDynamicItem){
        collisionBehavior.removeItem(item)
        itemDynamicBehavior.removeItem(item)
    }
    
    override init() {
        super.init()
        addChildBehavior(collisionBehavior)
        addChildBehavior(itemDynamicBehavior)
    }
    
    convenience init(in animator: UIDynamicAnimator) {
        self.init()
        animator.addBehavior(self)
    }
    
    
}

extension CGFloat {
    var arc4random: CGFloat {
        if self > 0 {
            return CGFloat(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -CGFloat(arc4random_uniform(UInt32(self)))
        } else {
            return 0
        }
    }
}
