//
//  Cell.swift
//  CC085-The Game of Life
//
//  Created by Bob Voorneveld on 22-02-18.
//  Copyright © 2018 Bob Voorneveld. All rights reserved.
//

import SpriteKit

class Cell: SKNode {
    let row: Int
    let col: Int
    
    var value = 0
    var newValue = 0
    var shape: SKShapeNode!

    init(row: Int, col: Int, width: CGFloat, height: CGFloat) {
        self.row = row
        self.col = col
        super.init()
        
        position = CGPoint(x: CGFloat(col) * width, y: CGFloat(row) * height)
        shape = SKShapeNode(rect: CGRect(x: 0, y: 0, width: width, height: height))
        shape.strokeColor = .black
        shape.fillColor = .white
        shape.position = CGPoint(x: -width / 2, y: -height / 2)
        addChild(shape)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(neighbors: [Cell]) {
        var sum = 0
        for cell in neighbors {
            sum += cell.value
        }
        
        if value == 0 && sum == 3 {
            newValue = 1
        } else if value == 1 && (sum < 2 || sum > 3) {
            newValue = 0
        } else {
            newValue = value
        }
    }
    
    func nextGeneration() {
        if newValue != value {
            value = newValue
            shape.fillColor = value == 1 ? .black : .white
        }
    }
}
