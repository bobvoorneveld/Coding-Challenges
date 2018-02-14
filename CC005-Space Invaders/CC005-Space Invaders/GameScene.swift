//
//  GameScene.swift
//  CC005-Space Invaders
//
//  Created by Bob Voorneveld on 06-02-18.
//  Copyright © 2018 Bob Voorneveld. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    private var ship: Ship!
    
    private var flowers = [Flower]()
    private var drops = [Drop]()
    
    override func didMove(to view: SKView) {
        ship = Ship()
        ship.position.y = -frame.height / 2
        
        addChild(ship)
        
        for i in 0...8 {
            let flower = Flower(x: -frame.width / 2 + 80.0 + CGFloat(i * 80), y: frame.height/2 - 100)
            addChild(flower)
            flowers.append(flower)
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        ship.move()
        for (index, drop) in drops.enumerated() {
            drop.move(scene: self)
            
            for flower in flowers {
                if drop.hits(flower) {
                    drop.removeFromParent()
                    drops.remove(at: index)
                    flower.grow()
                }
            }
            if drop.position.y > size.height / 2 {
                drop.removeFromParent()
                drops.remove(at: index)
            }
        }
        
        var shift = false
        for flower in flowers {
            flower.move()
            if abs(flower.position.x) > size.width / 2 {
                shift = true
            }
        }
        
        if shift {
            flowers.forEach({$0.shiftDown()})
        }
    }
    
    override func keyDown(with event: NSEvent) {
        switch event.keyCode {
        case 49:
            fireDrop()
        case 123:
            ship.direction = .left
        case 124:
            ship.direction = .right
        default: break
        }
    }
    
    override func keyUp(with event: NSEvent) {
        if event.keyCode == 123 || event.keyCode == 124 {
            ship.direction = .none
        }
    }
    
    func fireDrop() {
        let drop = Drop(position: ship.position)
        addChild(drop)
        drops.append(drop)
    }
}
