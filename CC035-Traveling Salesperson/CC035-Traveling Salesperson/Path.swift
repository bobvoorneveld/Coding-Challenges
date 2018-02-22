//
//  Path.swift
//  CC035-Traveling Salesperson
//
//  Created by Bob Voorneveld on 20-02-18.
//  Copyright © 2018 Bob Voorneveld. All rights reserved.
//

import Foundation

struct Path {
    let order: [Int]
    let distance: Double
    let fitness: Double
    var normalizedFitness: Double = 0.0
    
    init(order: [Int], distance: Double) {
        self.order = order
        self.distance = distance
        self.fitness = 1 / (pow(distance, 2) + 1)
    }
}

func ==(lhs: Path, rhs: Path) -> Bool {
    return lhs.order == rhs.order
}
