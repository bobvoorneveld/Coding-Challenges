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
    let width: CGFloat
    let height: CGFloat
    
    var fill: SKShapeNode?
    
    // Path finding
    var f = 0.0
    var g = 0.0
    var h = 0.0
    var previous: Cell?

    var visited = false {
        didSet {
            if visited {
                fill?.removeFromParent()
            }
        }
    }
    
    private var highLightRect: SKShapeNode?
    var highlight = false {
        didSet {
            if highlight && highLightRect == nil {
                closedPathRect?.removeFromParent()
                highLightRect = SKShapeNode(rect: CGRect(x: 0, y: 0, width: width, height: height))
                highLightRect!.lineWidth = 0
                highLightRect!.fillColor = NSColor(calibratedRed: 19/255.0, green: 39/255.0, blue: 71/255.0, alpha: 1.0)
                highLightRect!.zPosition = 1
                addChild(highLightRect!)
            } else {
                highLightRect?.removeFromParent()
                highLightRect = nil
                if let closed = closedPathRect, closed.parent == nil {
                    addChild(closed)
                }
            }
        }
    }
    
    private var closedPathRect: SKShapeNode?
    var closedPath = false {
        didSet {
            if closedPath && closedPathRect == nil {
                closedPathRect = SKShapeNode(rect: CGRect(x: 0, y: 0, width: width, height: height))
                closedPathRect!.lineWidth = 0
                closedPathRect!.fillColor = NSColor(calibratedRed: 168/255.0, green: 84/255.0, blue: 42/255.0, alpha: 1.0)
                closedPathRect!.zPosition = 0
                addChild(closedPathRect!)
            } else {
                closedPathRect?.removeFromParent()
                closedPathRect = nil
            }
        }
    }

    var top: SKNode?
    var right: SKNode?

    init(i: Int, j: Int, width: CGFloat, height: CGFloat) {
        self.i = i
        self.j = j
        self.width = width
        self.height = height
        super.init()
        top = createLineNode(start: CGPoint(x: 0, y: height), end: CGPoint(x: width, y: height))
        top?.zPosition = 2
        addChild(top!)
        right = createLineNode(start: CGPoint(x: width, y: height), end: CGPoint(x: width, y: 0))
        right?.zPosition = 2
        addChild(right!)

        fill = SKShapeNode(rect: CGRect(x: 0, y: 0, width: width, height: height))
        fill!.lineWidth = 0
        fill!.fillColor = .darkGray
        fill!.zPosition = -1
        addChild(fill!)

        position = CGPoint(x: i * width, y: j * height)
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
    
    func neighbors(_ grid: Grid<Cell>) -> Set<Cell> {
        var neighbors = Set<Cell>()
            if let topCell = grid[i, j + 1], top == nil {
                neighbors.insert(topCell)
            }
            if let rightCell = grid[i + 1, j], right == nil {
                neighbors.insert(rightCell)
            }
        if let bottomCell = grid[i, j - 1], bottomCell.top == nil {
            neighbors.insert(bottomCell)
        }
        if let leftCell = grid[i - 1, j], leftCell.right == nil {
            neighbors.insert(leftCell)
        }
        return neighbors
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

extension Cell {
    static func dummy(_ f: Double) -> Cell {
        let dummyCell = Cell(i: -1, j: -1, width: -1, height: -1)
        dummyCell.f = f
        return dummyCell
    }
}

func *(lhs: Int, rhs: CGFloat) -> CGFloat {
    return CGFloat(lhs) * rhs
}

func index(i: Int, j: Int, cols: Int) -> Int {
    return i + j * cols
}
