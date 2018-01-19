//
//  GameScene.swift
//  CC003-The Snake Game
//
//  Created by Bob Voorneveld on 16-01-18.
//  Copyright © 2018 Bob Voorneveld. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    struct Configuration {
        static let scale: CGFloat = 20
        static let framesPerSecond = 10.0
    }
    
    var scale: CGFloat = 10
    var snake: Snake!
    
    var food: Food!
    
    var playfieldRect: CGRect!
    var lastUpdateTime: TimeInterval = 0
    
    override func didMove(to view: SKView) {
        snake = Snake(position: CGPoint(x: 0, y: 0), size: Configuration.scale)
        addChild(snake.node)

        playfieldRect = view.bounds.insetBy(dx: Configuration.scale, dy: Configuration.scale)
        playfieldRect = playfieldRect.offsetBy(dx: -view.bounds.width / 2, dy: -view.bounds.height / 2)
        let border = SKShapeNode(rect: playfieldRect)
        border.position = .zero
        addChild(border)

        food = Food(position: pickLocation(), size: Configuration.scale)
        addChild(food.node)
    }
    
    override func keyDown(with event: NSEvent) {
        switch event.keyCode {
        case 123:
            snake.changeDirection(.left)
        case 124:
            snake.changeDirection(.right)
        case 125:
            snake.changeDirection(.down)
        case 126:
            snake.changeDirection(.up)
        default:
            print("keyDown: \(event.characters!) keyCode: \(event.keyCode)")
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard (currentTime - lastUpdateTime) > (60.0 / Configuration.framesPerSecond / 60) else {
            return
        }
        lastUpdateTime = currentTime
        guard !snake.checkDeath(playfield: playfieldRect) else {
            print("game over!")
            return
        }
        if let node = snake.update() {
            addChild(node)
        }
        if snake.eat(food) {
            food.remove()
            food = Food(position: pickLocation(), size: Configuration.scale)
            addChild(food.node)
        }
    }
}

extension GameScene {
    private func pickLocation() -> CGPoint {
        let cols = UInt32(playfieldRect.width / Configuration.scale)
        let rows = UInt32(playfieldRect.height / Configuration.scale)

        return CGPoint(x: playfieldRect.width / 2 - CGFloat(arc4random_uniform(cols)) * Configuration.scale - Configuration.scale,
                       y: playfieldRect.height / 2 - CGFloat(arc4random_uniform(rows)) * Configuration.scale - Configuration.scale)
    }
}

