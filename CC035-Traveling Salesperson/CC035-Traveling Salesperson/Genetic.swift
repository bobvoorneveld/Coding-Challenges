//
//  Genetic.swift
//  CC035-Traveling Salesperson
//
//  Created by Bob Voorneveld on 20-02-18.
//  Copyright © 2018 Bob Voorneveld. All rights reserved.
//

import SpriteKit

let populationSize = 100
let learningRate: Double = 0.05

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
            
            if pathA == pathB {
                let newPath = mutate(pathA, mutationRate: learningRate)
                newPopulation.append(newPath)
            } else {
                let newPath = crossOver(pathA, pathB)
                newPopulation.append(newPath)
            }
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
        while true {
            let index = random(populationSize)
            if random() < population[index].normalizedFitness {
                return population[index]
            }
        }
    }
    
    private func crossOver(_ a: Path, _ b: Path) -> Path {
        let switchPoint = random(1, a.order.count)
        var newOrder = Array(a.order[0 ..< switchPoint])
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
            if random() < mutationRate {
                let i = random(1, path.order.count - 1)
                let j = random(1, path.order.count - 1)
                order.swapAt(i, j)
            }
        }
        let distance = createPath(from: order.map { nodes[$0] }) ?? 0
        return Path(order: order, distance: distance)
    }
    
    func normalizePopulation() {
        var max = 0.0
        for path in population {
            if path.fitness > max {
                max = path.fitness
            }
        }
        
        for i in 0 ..< population.count {
            population[i].normalizedFitness = population[i].fitness / max
        }
    }
}
