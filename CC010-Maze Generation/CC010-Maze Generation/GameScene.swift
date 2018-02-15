//
//  GameScene.swift
//  CC010-Maze Generation
//
//  Created by Bob Voorneveld on 15-02-18.
//  Copyright © 2018 Bob Voorneveld. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    let w: CGFloat = 15.0
    let interval = 0.0005
    var cols: Int!
    var rows: Int!
    
    var grid: Grid<Cell>!
    var currentCell: Cell!
    
    var stack = [Cell]()
    
    var lastUpdate: TimeInterval = 0
    
    override func didMove(to view: SKView) {
        rows = Int(size.height / w)
        cols = Int(size.width / w)
        
        grid = Grid<Cell>(rows: rows, cols: cols)
        
        anchorPoint = CGPoint(x: 0, y: 0)
        for j in 0 ..< rows {
            for i in 0 ..< cols {
                let cell = Cell(i: i, j: j, size: w)
                addChild(cell)
                grid[i, j] = cell
            }
        }
        currentCell = grid[0, 0]
        currentCell.highlight = true
        stack.append(currentCell)
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        guard currentTime - lastUpdate > interval else {
            return
        }
        lastUpdate = currentTime
        
        // Step 1
        if let next = currentCell.checkNeighbors(grid: grid) {
            next.visited = true
            next.highlight = true
            currentCell.highlight = false

            // Step 2
            stack.append(next)

            // Step 3
            removeWalls(currentCell, next)
            
            // Step 4
            currentCell = next
            currentCell.visited = true
            
        } else if stack.count > 0 {
            currentCell.highlight = false
            currentCell = stack.popLast()
            currentCell.highlight = true
        }
    }
    
    private func removeWalls(_ current: Cell, _ next: Cell) {
        let x = current.i - next.i
        let y = current.j - next.j
        if x == 1 {
            next.right?.removeFromParent()
        } else if x == -1 {
            current.right?.removeFromParent()
        } else if y == 1 {
            next.top?.removeFromParent()
        } else if y == -1 {
            current.top?.removeFromParent()
        }
    }
}
