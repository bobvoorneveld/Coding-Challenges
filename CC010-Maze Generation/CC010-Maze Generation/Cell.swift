//
//  Cell.swift
//  CC010-Maze Generation
//
//  Created by Bob Voorneveld on 15-02-18.
//  Copyright © 2018 Bob Voorneveld. All rights reserved.
//

import SpriteKit

class Cell: SKNode {
    let i: Int
    let j: Int
    let size: CGFloat
    
    var fill: SKShapeNode?

    var visited = false {
        didSet {
            if visited {
                fill?.removeFromParent()
            }
        }
    }
    
    var highLightRect: SKShapeNode?
    var highlight = false {
        didSet {
            if highlight {
                highLightRect = SKShapeNode(rect: CGRect(x: 0, y: 0, width: size, height: size))
                highLightRect!.lineWidth = 0
                highLightRect!.fillColor = .red
                highLightRect!.zPosition = 0
                addChild(highLightRect!)
            } else {
                highLightRect?.removeFromParent()
                highLightRect = nil
            }
        }
    }

    var top: SKNode?
    var right: SKNode?

    init(i: Int, j: Int, size: CGFloat) {
        self.i = i
        self.j = j
        self.size = size
        super.init()
        top = createLineNode(start: CGPoint(x: 0, y: size), end: CGPoint(x: size, y: size))
        top?.zPosition = 1
        addChild(top!)
        right = createLineNode(start: CGPoint(x: size, y: size), end: CGPoint(x: size, y: 0))
        right?.zPosition = 1
        addChild(right!)

        fill = SKShapeNode(rect: CGRect(x: 0, y: 0, width: size, height: size))
        fill!.lineWidth = 0
        fill!.fillColor = .darkGray
        fill!.zPosition = -1
        addChild(fill!)

        position = CGPoint(x: i * size, y: j * size)
    }
    
    
    func checkNeighbors(grid: Grid<Cell>) -> Cell? {
        var neighbors = [Cell]()
        if let top = grid[i, j + 1], !top.visited {
            neighbors.append(top)
        }
        if let right = grid[i + 1, j], !right.visited {
            neighbors.append(right)
        }
        if let bottom = grid[i, j - 1], !bottom.visited {
            neighbors.append(bottom)
        }
        if let left = grid[i - 1, j], !left.visited {
            neighbors.append(left)
        }
        
        if neighbors.count > 0 {
            let index = Int(arc4random_uniform(UInt32(neighbors.count)))
            return neighbors[index]
        } else {
            return nil
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createLineNode(start: CGPoint, end: CGPoint) -> SKShapeNode {
        let pathToDraw: CGMutablePath = CGMutablePath()
        let node: SKShapeNode = SKShapeNode(path:pathToDraw)
        pathToDraw.move(to: start)
        pathToDraw.addLine(to: end)
        
        node.path = pathToDraw
        return node
    }
}


func *(lhs: Int, rhs: CGFloat) -> CGFloat {
    return CGFloat(lhs) * rhs
}

func index(i: Int, j: Int, cols: Int) -> Int {
    return i + j * cols
}
