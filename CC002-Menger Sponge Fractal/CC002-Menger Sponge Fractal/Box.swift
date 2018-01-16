//
//  Box.swift
//  Menger Sponge Fractal
//
//  Created by Bob Voorneveld on 16-01-18.
//  Copyright © 2018 Bob Voorneveld. All rights reserved.
//

import Foundation
import SceneKit

class Box {
    let position: SCNVector3
    let size: CGFloat
    let node: SCNNode
    
    init(x: CGFloat, y: CGFloat, z: CGFloat, size: CGFloat, color: NSColor? = .lightGray) {
        self.size = size
        
        position = SCNVector3(x: x, y: y, z: z)
        
        let boxGeo = SCNBox(width: size, height: size, length: size, chamferRadius: 0)
        boxGeo.materials.first?.diffuse.contents = color
        node = SCNNode(geometry: boxGeo)
        node.position = position
    }
    
    
    func generate() -> [Box] {
        var boxes = [Box]()
        let newSize = size / 3
        for x in -1 ..< 2 {
            for y in -1 ..< 2 {
                for z in -1 ..< 2 {
                    let sum = abs(x) + abs(y) + abs(z)
                    if sum > 1 {
                        let box = Box(x: position.x + (CGFloat(x) * newSize),
                                      y: position.y + (CGFloat(y) * newSize),
                                      z: position.z + (CGFloat(z) * newSize),
                                      size: newSize)
                        boxes.append(box)
                    }
                }
            }
        }
        return boxes
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
