//
//  Random.swift
//  CC085-The Game of Life
//
//  Created by Bob Voorneveld on 22-02-18.
//  Copyright © 2018 Bob Voorneveld. All rights reserved.
//

import Foundation

func random(_ n: Int) -> Int {
    return Int(arc4random_uniform(UInt32(n + 1)))
}
