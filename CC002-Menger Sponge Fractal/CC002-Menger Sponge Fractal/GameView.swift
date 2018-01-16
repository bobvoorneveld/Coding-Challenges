//
//  GameView.swift
//  Menger Sponge Fractal
//
//  Created by Bob Voorneveld on 16-01-18.
//  Copyright © 2018 Bob Voorneveld. All rights reserved.
//

import Foundation
import SceneKit
import QuartzCore

class GameView: SCNView {
    
    var boxes = [Box]()
    
    override func viewDidMoveToSuperview() {
        allowsCameraControl = true
        autoenablesDefaultLighting = true
        
        scene = SCNScene()
        isPlaying = true
        
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 10)
        
        scene?.rootNode.addChildNode(cameraNode)
        
        createRootBox()
    }
    
    func createRootBox() {
        let rootBox = Box(x: 0, y: 0, z: 0, size: 5)
        scene?.rootNode.addChildNode(rootBox.node)
        boxes.append(rootBox)
    }
    
    override func keyDown(with event: NSEvent) {
        guard event.keyCode == 49 && boxes.count < 500 else {
            return
        }
        
        var newBoxes = [Box]()
        for box in boxes {
            newBoxes.append(contentsOf: box.generate())
            box.node.removeFromParentNode()
        }
        boxes = newBoxes
        for box in boxes {
            scene?.rootNode.addChildNode(box.node)
        }
    }
}
