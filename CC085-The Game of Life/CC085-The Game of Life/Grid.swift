//
//  Grid.swift
//  CC085-The Game of Life
//
//  Created by Bob Voorneveld on 22-02-18.
//  Copyright © 2018 Bob Voorneveld. All rights reserved.
//

import Foundation

class Grid<T> {
    let rows: Int
    let cols: Int
    private var storage: [T?]

    init(rows: Int, cols: Int) {
        self.rows = rows
        self.cols = cols
        self.storage = Array<T?>(repeating: nil, count: rows * cols)
    }
    
    subscript(i: Int, j: Int) -> T? {
        get {
            let row = (i + rows) % rows
            let col = (j + cols) % cols
            return storage[row * cols + col]
        }
        set {
            let row = (i + rows) % rows
            let col = (j + cols) % cols
            storage[row * cols + col] = newValue
        }
    }
    
    func neighbors(_ i: Int, _ j: Int) -> [T] {
        var neighbors = [T?]()
        neighbors.append(self[i - 1, j - 1])
        neighbors.append(self[i, j - 1])
        neighbors.append(self[i + 1, j - 1])
        neighbors.append(self[i - 1, j])
        neighbors.append(self[i + 1, j])
        neighbors.append(self[i - 1, j + 1])
        neighbors.append(self[i, j + 1])
        neighbors.append(self[i + 1, j + 1])
        return neighbors.filter { $0 != nil } as! [T]
    }
}
