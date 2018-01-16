//
//  GameScene.swift
//  CC001-Starfield
//
//  Created by Bob Voorneveld on 16-01-18.
//  Copyright © 2018 Bob Voorneveld. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    struct Configuration {
        static let numberOfStars = 200
        static let maxSpeed: CGFloat = 50.0
    }
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    private var stars = [Star]()
    private var vel: CGFloat = 40
    private var showCircle = true

    override func didMove(to view: SKView) {

        let options: NSTrackingArea.Options = [.mouseMoved, .activeInKeyWindow]
        let trackingArea = NSTrackingArea(rect: view.frame, options: options, owner: self, userInfo: nil)
        view.addTrackingArea(trackingArea)

        for _ in 0 ..< Configuration.numberOfStars {
            let star = Star(screenWidth: size.width, screenHeight: size.height)
            addChild(star)
            stars.append(star)
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        for star in stars {
            star.update(speed: vel, showCircle: showCircle)
        }
    }
    
    override func mouseMoved(with event: NSEvent) {
        let location = event.location(in: self)
        vel = map(location.x, -size.width / 2 , size.width / 2, 0, Configuration.maxSpeed)
        showCircle = location.y < 0
    }
}
