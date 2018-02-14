//
//  Ship.swift
//  Space Invaders
//
//  Created by Bob Voorneveld on 06-02-18.
//  Copyright © 2018 Bob Voorneveld. All rights reserved.
//

import SpriteKit


class Ship: SKNode {
    enum Move: CGFloat {
        case none = 0.0
        case left = -1.0
        case right = 1.0
    }
    
    var direction = Move.none

    override init() {
        super.init()
        let body = SKShapeNode(rect: CGRect(x: -5, y: 0, width: 10, height: 50))
        body.fillColor = .white
        addChild(body)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func move() {
        position.x += direction.rawValue * 10
    }
}
