//
//  Grid.swift
//  CC010-Maze Generation
//
//  Created by Bob Voorneveld on 15-02-18.
//  Copyright © 2018 Bob Voorneveld. All rights reserved.
//

import Foundation


class Grid<CellType> {
    let rows: Int
    let cols: Int
    
    private var cells: [CellType?]!

    init(rows: Int, cols: Int) {
        self.rows = rows
        self.cols = cols
        cells = Array<CellType?>(repeating: nil, count: rows * cols)
    }
    
    subscript(_ i: Int, _ j: Int) -> CellType? {
        get {
            guard i >= 0 && i < cols && j >= 0 && j < rows else {
                return nil
            }
            return cells[i + j * cols]
        }
        set {
            cells[i + j * cols] = newValue
        }
    }
}
