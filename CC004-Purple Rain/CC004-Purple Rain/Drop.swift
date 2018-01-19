//
//  Drop.swift
//  CC004-Purple Rain
//
//  Created by Bob Voorneveld on 19-01-18.
//  Copyright © 2018 Bob Voorneveld. All rights reserved.
//

import SpriteKit

class Drop {
    
    let node: SKShapeNode
    let speed: CGFloat
    let topOfScreen: CGFloat
    let z: CGFloat
    
    init(xPosition: CGFloat, topOfScreen: CGFloat) {
        self.topOfScreen = topOfScreen
        z = pow(CGFloat(arc4random_uniform(4)), 2.0)
        let height = map(z, 0, 16, 10, 50)
        let width = map(z, 0, 16, 1, 2)
        speed = map(z, 0, 16, 5, 20)
        node = SKShapeNode(rect: CGRect(origin: .zero, size: CGSize(width: width, height: height)))
        node.fillColor = NSColor(calibratedRed: 138/255.0, green: 43/255.0, blue: 226/255.0, alpha: 1)
        node.strokeColor = NSColor(calibratedRed: 138/255.0, green: 43/255.0, blue: 226/255.0, alpha: 1)
        
        let y = topOfScreen + CGFloat(arc4random_uniform(UInt32(topOfScreen)))
        node.position = CGPoint(x: xPosition, y: y)
    }
    
    func update() {
        node.position.y -= speed
        if node.position.y < -topOfScreen {
            node.position.x += -5.0 + CGFloat(arc4random_uniform(10))
            node.position.y = topOfScreen + CGFloat(arc4random_uniform(200))
        }
    }
}

