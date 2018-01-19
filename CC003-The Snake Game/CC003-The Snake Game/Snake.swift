//
//  Snake.swift
//  CC003-The Snake Game
//
//  Created by Bob Voorneveld on 16-01-18.
//  Copyright © 2018 Bob Voorneveld. All rights reserved.
//

import SpriteKit

class Snake {
    
    enum Direction: Int {
        case up = 0
        case left = 1
        case down = 2
        case right = 3
    }
    
    var position: CGPoint
    private var direction: Direction = .right
    private var size: CGFloat
    var tailLength = 0
    var tail = [SKShapeNode]()
    
    let node: SKShapeNode
    
    init(position: CGPoint, size: CGFloat) {
        self.position = position
        self.size = size
        
        node = SKShapeNode(rect: CGRect(x: 0, y: 0, width: size, height: size))
        node.position = position
        node.fillColor = .white
    }
    
    func update() -> SKShapeNode? {
        var newNode: SKShapeNode?
        if tailLength > tail.count {
            newNode = createTailNode(position: position)
            tail.append(newNode!)
        } else {
            for (index, tailNode) in tail.enumerated() {
                if index == tail.count - 1 {
                    tailNode.position = position
                } else {
                    tailNode.position = tail[index + 1].position
                }
            }
        }

        switch direction {
        case .up:
            position.y += size
        case .down:
            position.y -= size
        case .left:
            position.x -= size
        case .right:
            position.x += size
        }
        node.position = position
        
        return newNode
    }
    
    func changeDirection(_ new: Direction) {
        if direction.rawValue != (new.rawValue + 2) % 4 {
            direction = new
        }
    }
    
    func eat(_ food: Food) -> Bool {
        if food.position == position {
            tailLength += 1
            return true
        }
        return false
    }
    
    func checkDeath(playfield: CGRect) -> Bool {
        var death = !playfield.contains(position)
        tail.forEach { tailNode in
            if tailNode.position == position {
                death = true
            }
        }
        if death {
            tail.forEach { tailNode in
                tailNode.removeFromParent()
            }
            tailLength = 0
            tail = [SKShapeNode]()
            position = CGPoint(x: 0, y: 0)
            direction = .right
        }
        return death
    }
    
    func createTailNode(position: CGPoint) -> SKShapeNode {
        let newNode = SKShapeNode(rect: CGRect(origin: .zero, size: CGSize(width: size, height: size)))
        newNode.fillColor = .white
        newNode.position = position
        return newNode
    }
}
