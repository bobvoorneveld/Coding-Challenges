//
//  Genetic.swift
//  CC035-Traveling Salesperson
//
//  Created by Bob Voorneveld on 20-02-18.
//  Copyright © 2018 Bob Voorneveld. All rights reserved.
//

import SpriteKit

let populationSize = 100
let learningRate: Double = 0.1

extension GameScene {
    
    func createNewPopulation() {
        let order = [Int](1 ..< nodes.count)
        population.removeAll()
        for _ in 0 ..< populationSize {
            var newOrder = order.shuffled()
            newOrder.insert(0, at: 0)
            let distance = createPath(from: newOrder.map { nodes[$0] }) ?? 0
            population.append(Path(order: newOrder, distance: distance))
        }
    }

    func nextGeneration() {
        guard population.count > 5 && nodes.count > 2 else {
            return
        }
        
        var newPopulation = [Path]()
        
        let reUse = Int(Double(population.count) * 0.95)
        for _ in 1 ..< reUse {
            let pathA = pickOne()
            let pathB = pickOne()
            
            var newPath = crossOver(pathA, pathB)
            newPath = mutate(newPath, mutationRate: learningRate)
            newPopulation.append(newPath)
        }
        
        for _ in 0 ... population.count - reUse {
            var randomOrder = [Int](1 ..< nodes.count).shuffled()
            randomOrder.insert(0, at: 0)
            let distance = createPath(from: randomOrder.map { nodes[$0] }) ?? 0
            let path = Path(order: randomOrder, distance: distance)
            newPopulation.append(path)
        }
        
        population = newPopulation
    }
    
    private func pickOne() -> Path {
        var index = 0
        var r = Double(arc4random()) / Double(Int.max)
        
        while r > 0 {
            r = r - population[index].distance
            index += 1
        }
        index -= 1
        return population[index]
    }
    
    private func crossOver(_ a: Path, _ b: Path) -> Path {
        let startIndex = Int(arc4random_uniform(UInt32(a.order.count - 1)))
        let endIndex = startIndex + 1 + Int(arc4random_uniform(UInt32(a.order.count - startIndex - 1)))
        var newOrder = Array(a.order[startIndex ... endIndex])
        
        for item in b.order {
            if !newOrder.contains(item) {
                newOrder.append(item)
            }
        }
        
        let distance = createPath(from: newOrder.map { nodes[$0] }) ?? 0
        return Path(order: newOrder, distance: distance)
    }
    
    private func mutate(_ path: Path, mutationRate: Double) -> Path {
        var order = path.order
        guard nodes.count > 2 else {
            return path
        }
        for _ in 0 ..< nodes.count {
            if (Double(arc4random()) / Double(UInt32.max)) < mutationRate {
                let i = 1 + Int(arc4random_uniform(UInt32(order.count - 1)))
                let j = 1 + Int(arc4random_uniform(UInt32(order.count - 1)))
                order.swapAt(i, j)
            }
        }
        let distance = createPath(from: order.map { nodes[$0] }) ?? 0
        return Path(order: order, distance: distance)
    }
    
    func normalizePopulation() {
        var sum = 0.0
        for path in population {
            sum += path.distance
        }
        
        for i in 0 ..< population.count {
            population[i].distance = population[i].distance / sum
        }
    }
}
