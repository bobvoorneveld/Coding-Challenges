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
    var distance: Double = 0.0
}

func ==(lhs: Path, rhs: Path) -> Bool {
    return lhs.order == rhs.order
}
