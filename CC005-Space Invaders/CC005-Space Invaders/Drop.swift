//
//  Drop.swift
//  Space Invaders
//
//  Created by Bob Voorneveld on 06-02-18.
//  Copyright © 2018 Bob Voorneveld. All rights reserved.
//

import SpriteKit

class Drop: SKNode {
    let radius = 5
    init(position: CGPoint) {
        super.init()
        self.position = position
        let body = SKShapeNode(ellipseOf: CGSize(width: radius * 2, height: radius * 2))
        body.fillColor = .blue
        body.lineWidth = 0
        addChild(body)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func move(scene: SKScene) {
        position.y += 3
        if position.y > scene.size.height / 2 {
            removeFromParent()
        }
    }
    
    public func hits(_ flower: Flower) -> Bool {
        return distance(position, flower.position) < (CGFloat(radius) + CGFloat(flower.radius) * flower.scale)
    }
}

func distance(_ a: CGPoint, _ b: CGPoint) -> CGFloat {
    let xDist = a.x - b.x
    let yDist = a.y - b.y
    return CGFloat(sqrt((xDist * xDist) + (yDist * yDist)))
}
