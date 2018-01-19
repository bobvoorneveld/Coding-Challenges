//
//  GameScene.swift
//  CC004-Purple Rain
//
//  Created by Bob Voorneveld on 19-01-18.
//  Copyright © 2018 Bob Voorneveld. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    struct Configuration {
        static let numberOfDrops = 500
    }
    
    var drops = [Drop]()
    
    override func didMove(to view: SKView) {
        backgroundColor = NSColor(calibratedRed: 230/255.0, green: 230/255.0, blue: 250/255.0, alpha: 1)
        for _ in 0 ..< Configuration.numberOfDrops {
            let xPosition = -size.width / 2 + CGFloat(arc4random_uniform(UInt32(size.width)))
            let drop = Drop(xPosition: xPosition, topOfScreen: size.height / 2)
            addChild(drop.node)
            drops.append(drop)
        }
    }

    override func update(_ currentTime: TimeInterval) {
        drops.forEach { $0.update() }
    }
}
