//
//  Food.swift
//  CC003-The Snake Game
//
//  Created by Bob Voorneveld on 18-01-18.
//  Copyright © 2018 Bob Voorneveld. All rights reserved.
//

import SpriteKit

class Food {
    
    let position: CGPoint
    private let size: CGFloat
    
    let node: SKShapeNode
    
    init(position: CGPoint, size: CGFloat) {
        self.position = position
        self.size = size
        
        node = SKShapeNode(rect: CGRect(x: 0, y: 0, width: size, height: size))
        node.position = position
        node.fillColor = .purple
        node.strokeColor = .purple
    }
    
    func remove() {
        node.removeFromParent()
    }
}
