//
//  GameScene.swift
//  CC085-The Game of Life
//
//  Created by Bob Voorneveld on 22-02-18.
//  Copyright © 2018 Bob Voorneveld. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    let resolution: CGFloat = 30.0
    var grid: Grid<Cell>!
    
    override func didMove(to view: SKView) {
        anchorPoint = .zero
        
        let rows = Int(size.height / resolution)
        let cols = Int(size.width / resolution)
        let width = size.width / CGFloat(cols)
        let height = size.height / CGFloat(rows)
        grid = Grid<Cell>(rows: rows, cols: cols)

        for i in 0 ..< grid.rows {
            for j in 0 ..< grid.cols {
                let cell = Cell(row: i, col: j, width: width, height: height)
                cell.value = random(1)
                grid[i, j] = cell
                addChild(cell)
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        for i in 0 ..< grid.rows {
            for j in 0 ..< grid.cols {
                let cell = grid[i, j]
                cell?.update(neighbors: grid.neighbors(i, j))
            }
        }

        for i in 0 ..< grid.rows {
            for j in 0 ..< grid.cols {
                let cell = grid[i, j]!
                cell.nextGeneration()
            }
        }
    }
    
    override func mouseDragged(with event: NSEvent) {
        if let cell = nodes(at: event.location(in: self)).first?.parent as? Cell {
            for neighbor in grid.neighbors(cell.row, cell.col) {
                neighbor.value = 1
            }
        }
    }

    override func mouseDown(with event: NSEvent) {
        if let cell = nodes(at: event.location(in: self)).first?.parent as? Cell {
            cell.value = 1
        }
    }
}
