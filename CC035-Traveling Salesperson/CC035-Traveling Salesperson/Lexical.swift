//
//  Lexical.swift
//  CC035-Traveling Salesperson
//
//  Created by Bob Voorneveld on 20-02-18.
//  Copyright © 2018 Bob Voorneveld. All rights reserved.
//

import SpriteKit

extension GameScene {
    func nextLexicographicalOrder() -> [SKShapeNode]? {
        guard arrangement.count > 1 else {
            return nil
        }
        
        
        var largestI = -1
        for i in 1 ..< arrangement.count - 1 {
            if arrangement[i] < arrangement[i + 1] {
                largestI = i
            }
        }
        
        guard largestI != -1 else {
            return nil
        }
        
        var largestJ = -1
        for j in 1 ..< arrangement.count {
            if arrangement[largestI] < arrangement[j]{
                largestJ = j
            }
        }
        
        arrangement.swapAt(largestI, largestJ)
        var lastPart = arrangement[(largestI + 1)...]
        lastPart.reverse()
        arrangement.replaceSubrange((largestI + 1)..., with: lastPart)
        
        return newOrderNodes()
    }
    
    private func newOrderNodes() -> [SKShapeNode] {
        return arrangement.map { nodes[$0] }
    }
    
    func factorial(_ n: Int) -> Int {
        if n == 1 {
            return 1
        }
        return n * factorial(n - 1)
    }
}
