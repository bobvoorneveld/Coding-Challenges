//
//  Star.swift
//  Starfield
//
//  Created by Bob Voorneveld on 16-01-18.
//  Copyright © 2018 Bob Voorneveld. All rights reserved.
//

import SpriteKit

class Star: SKNode {
    
    struct Configuration {
        static let maxSizeStar: CGFloat = 10
    }

    var screenWidth: CGFloat
    var screenHeight: CGFloat
    var x: CGFloat
    var y: CGFloat
    var z: CGFloat
    var pz: CGFloat
    
    var lineShape: SKShapeNode?
    let circle: SKShapeNode
    
    init(screenWidth: CGFloat, screenHeight: CGFloat) {
        self.screenWidth = screenWidth
        self.screenHeight = screenHeight
        x = CGFloat(arc4random_uniform(UInt32(screenWidth)))
        y = CGFloat(arc4random_uniform(UInt32(screenHeight)))
        z = CGFloat(arc4random_uniform(UInt32(screenWidth)))
        pz = z
        
        circle = SKShapeNode(ellipseOf: CGSize(width: 4, height: 4))
        circle.position = CGPoint(x: x - screenWidth / 2, y: y - screenHeight / 2)
        circle.fillColor = .white
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(speed: CGFloat, showCircle: Bool) {
        z = z - speed

        if z == 0.0 {
            z = 1.0
        }

        // New position of the star.
        let sx: CGFloat = map(x / z, 0, 1, 0, screenWidth)
        let sy: CGFloat = map(y / z, 0, 1, 0, screenHeight)
        
        circle.position = CGPoint(x: sx, y: sy)
        
        let r = map(z, 0, screenWidth, Configuration.maxSizeStar, 1)
        let rect = CGRect(origin: .zero, size: CGSize(width: r, height: r))
        circle.path = CGPath(ellipseIn: rect, transform: nil)
        
        // Remove the circle and only add when asked.
        circle.removeFromParent()
        if showCircle {
            addChild(circle)
        }
        
        // Remove the line and add in the new line between previous point and current point.
        lineShape?.removeFromParent()
        
        // Previous point of the star.
        let px = map(x / pz, 0, 1, 0, screenWidth)
        let py = map(y / pz, 0, 1, 0, screenHeight)
        
        let line = CGMutablePath()
        line.move(to: CGPoint(x: px, y: py))
        line.addLine(to: CGPoint(x: sx, y: sy))
        
        lineShape = SKShapeNode()
        lineShape?.path = line
        lineShape?.strokeColor = .white
        lineShape?.lineWidth = 1.0
        lineShape?.position = .zero
        addChild(lineShape!)

        // Remove shapes and reset if z became to small (star is already long time off the screen.
        if z < 1 {
            lineShape?.removeFromParent()
            circle.removeFromParent()
            z = CGFloat(arc4random_uniform(UInt32(screenWidth)))
            x = -screenWidth / 2 + CGFloat(arc4random_uniform(UInt32(screenWidth)))
            y = -screenHeight / 2 + CGFloat(arc4random_uniform(UInt32(screenHeight)))
        }
        
        pz = z
    }
}
