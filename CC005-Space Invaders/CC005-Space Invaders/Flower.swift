//
//  Flower.swift
//  Space Invaders
//
//  Created by Bob Voorneveld on 06-02-18.
//  Copyright © 2018 Bob Voorneveld. All rights reserved.
//

import SpriteKit


class Flower: SKNode {
    let radius = 30
    let body: SKShapeNode
    var scale: CGFloat = 1.0
    var xDirection: CGFloat = 1.0
    
    init(x: CGFloat, y: CGFloat) {
        body = SKShapeNode(ellipseOf: CGSize(width: radius * 2, height: radius * 2))
        super.init()
        position.x = x
        position.y = y
        body.fillColor = NSColor.purple.withAlphaComponent(0.8)
        body.lineWidth = 0
        addChild(body)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func grow() {
        scale += 0.1
        body.setScale(scale)
    }
    
    func move() {
        position.x += xDirection
    }
    
    func shiftDown() {
        position.y -= 30.0
        xDirection *= -1
    }
}
