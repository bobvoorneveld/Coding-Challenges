//
//  Random.swift
//  CC035-Traveling Salesperson
//
//  Created by Bob Voorneveld on 20-02-18.
//  Copyright © 2018 Bob Voorneveld. All rights reserved.
//

import Foundation

extension MutableCollection {
    /// Shuffles the contents of this collection.
    mutating func shuffle() {
        let c = count
        guard c > 1 else { return }
        
        for (firstUnshuffled, unshuffledCount) in zip(indices, stride(from: c, to: 1, by: -1)) {
            let d: IndexDistance = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            let i = index(firstUnshuffled, offsetBy: d)
            swapAt(firstUnshuffled, i)
        }
    }
}

extension Sequence {
    /// Returns an array with the contents of this sequence, shuffled.
    func shuffled() -> [Iterator.Element] {
        var result = Array(self)
        result.shuffle()
        return result
    }
}

func random() -> Double {
    return Double(arc4random()) / 0xFFFFFFFF
}

func random(_ n: Int) -> Int {
    return Int(arc4random_uniform(UInt32(n)))
}

func random(_ min: Int, _ max: Int) -> Int {
    return random(max - min) + min
}

func random(_ n: CGFloat) -> CGFloat {
    return CGFloat(random()) * n
}

func random(_ min: CGFloat, _ max: CGFloat) -> CGFloat {
    return random(max - min) + min
}
