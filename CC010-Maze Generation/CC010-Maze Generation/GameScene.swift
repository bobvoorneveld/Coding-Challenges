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
    
    var cellWidth: CGFloat = 30.0
    var cellHeight: CGFloat = 30.0
    var cols: Int!
    var rows: Int!
    
    var grid: Grid<Cell>!
    var currentCell: Cell!
    
    var stack = [Cell]()
    var mazeDone = false
    var pathDone = false
    
    var finishCell: Cell!
    var openSet = Set<Cell>()
    var closedSet = Set<Cell>()

    var lastUpdate: TimeInterval = 0
    var interval: TimeInterval = 1 / 30.0
    
    override func didMove(to view: SKView) {
        rows = Int(size.height / cellWidth)
        cols = Int(size.width / cellHeight)
        cellWidth = size.width / CGFloat(cols)
        cellHeight = size.height / CGFloat(rows)
        
        grid = Grid<Cell>(rows: rows, cols: cols)
        
        anchorPoint = CGPoint(x: 0, y: 0)
        for j in 0 ..< rows {
            for i in 0 ..< cols {
                let cell = Cell(i: i, j: j, width: cellWidth, height: cellHeight)
                addChild(cell)
                grid[i, j] = cell
            }
        }
        currentCell = grid[0, 0]
        currentCell.highlight = true
        currentCell.visited = true
        stack.append(currentCell)

        finishCell = grid[cols - 1, rows - 1]!

        openSet.insert(grid[0,0]!)
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        guard currentTime - lastUpdate > interval else {
            return
        }

        lastUpdate = currentTime
        
        if !mazeDone {
            createNextMazePeace()
        } else if !pathDone {
            findPath()
        }
    }

    private func findPath() {
        hideCurrentPath(for: currentCell)
        currentCell = openSet.reduce(Cell.dummy(Double(rows * cols))) {
            ($0.f < $1.f) ? $0 : $1
        }
        currentCell.highlight = true
        if currentCell == finishCell {
            // DONE!
            currentCell.highlight = true
            showCurrentPath(for: currentCell)
            pathDone = true
            return
        }
        openSet.remove(currentCell)
        closedSet.insert(currentCell)
        currentCell.closedPath = true
        
        showCurrentPath(for: currentCell)
        
        for neighbor in currentCell.neighbors(grid) {
            guard !closedSet.contains(neighbor) else {
                continue
            }
            
            let tentativeG = currentCell.g + 1
            
            if !openSet.contains(neighbor) {
                neighbor.g = tentativeG
                openSet.insert(neighbor)
            } else if tentativeG >= neighbor.g {
                continue
            }
            
            neighbor.h = heuristic(neighbor, finishCell)
            neighbor.f = neighbor.g + neighbor.h
            neighbor.previous = currentCell
        }
    }

    private func showCurrentPath(for cell: Cell) {
        cell.highlight = true
        var previous = cell.previous
        while previous != nil {
            previous?.highlight = true
            previous = previous?.previous
        }
    }
    
    private func hideCurrentPath(for cell: Cell) {
        cell.highlight = false
        var previous = cell.previous
        while previous != nil {
            previous?.highlight = false
            previous = previous?.previous
        }
    }
    
    private func heuristic(_ start: Cell, _ end: Cell) -> Double {
        let xDist = Double(end.i) - Double(start.i)
        let yDist = Double(end.j) - Double(start.j)
        return Double(sqrt((xDist * xDist) + (yDist * yDist)))
    }

    private func createNextMazePeace() {
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
        } else {
            mazeDone = true
        }
    }
    
    private func removeWalls(_ current: Cell, _ next: Cell) {
        let x = current.i - next.i
        let y = current.j - next.j
        if x == 1 {
            next.right?.removeFromParent()
            next.right = nil
        } else if x == -1 {
            current.right?.removeFromParent()
            current.right = nil
        } else if y == 1 {
            next.top?.removeFromParent()
            next.top = nil
        } else if y == -1 {
            current.top?.removeFromParent()
            current.top = nil
        }
    }
}
