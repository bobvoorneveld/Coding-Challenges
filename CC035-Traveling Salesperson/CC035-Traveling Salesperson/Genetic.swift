//
//  Genetic.swift
//  CC035-Traveling Salesperson
//
//  Created by Bob Voorneveld on 20-02-18.
//  Copyright © 2018 Bob Voorneveld. All rights reserved.
//

import SpriteKit

let populationSize = 100
let learningRate: Double = 0.01

extension GameScene {
    
    func createNewPopulation() {
        let order = [Int](0 ..< nodes.count)
        population.removeAll()
        for _ in 0 ..< populationSize {
            let newOrder = order.shuffled()
            let distance = createPath(from: newOrder.map { nodes[$0] }) ?? 0
            population.append(Path(order: newOrder, distance: distance))
        }
    }

    func nextGeneration() {
        guard population.count > 5 && nodes.count > 2 else {
            return
        }
        
        var newPopulation = [Path]()
        if let bestPath = bestPath {
            newPopulation.append(bestPath)
        }
        
        let reUse = Int(Double(population.count) * 0.80)
        
        for _ in 1 ..< reUse {
            let pathA = pickOne()
            let pathB = pickOne()
            
            var newPath: Path
            if pathA == pathB {
                if random() < 0.3 {
                    newPath = crossOver(pathA, pathB)
                } else if random() < 0.5 {
                    newPath = crossOver2(pathA, pathB)
                } else {
                    newPath = crossOver3(pathA, pathB)
                }
            } else {
                newPath = mutate(pathA, mutationRate: learningRate)
            }
            if newPath.distance == shortestDistance {
                bestPath = newPath
            }
            newPopulation.append(newPath)
        }
        
        for _ in 0 ... population.count - reUse {
            let randomOrder = [Int](0 ..< nodes.count).shuffled()
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
    
    private func crossOver3(_ a: Path, _ b: Path) -> Path {
        var newOrder = Array<Int>(repeating: -1, count: a.order.count)
        let startIndex = random(0, a.order.count)
        let endIndex = random(startIndex + 1, a.order.count)

        for i in 0 ..< a.order.count {
            if (startIndex ..< endIndex).contains(i) {
                newOrder[i] = a.order[i]
            }
        }
        
        for i in 0 ..< b.order.count {
            if !newOrder.contains(b.order[i]) {
                for j in 0 ..< newOrder.count {
                    if newOrder[j] == -1 {
                        newOrder[j] = b.order[i]
                        break
                    }
                }
            }
        }
        
        let distance = createPath(from: newOrder.map { nodes[$0] }) ?? 0
        return Path(order: newOrder, distance: distance)
    }

    private func crossOver2(_ a: Path, _ b: Path) -> Path {
        let switchpoint = random(0, a.order.count)
        var newOrder = Array(a.order[0 ..< switchpoint])
        for item in b.order {
            if !newOrder.contains(item) {
                newOrder.append(item)
            }
        }
        let distance = createPath(from: newOrder.map { nodes[$0] }) ?? 0
        return Path(order: newOrder, distance: distance)
    }
    private func crossOver(_ a: Path, _ b: Path) -> Path {
        let startIndex = random(0, a.order.count)
        let endIndex = random(startIndex + 1, a.order.count)
        let removingItems = a.order[startIndex ..< endIndex]
        var addingItems = [Int]()
        for item in b.order {
            if removingItems.contains(item) {
                addingItems.append(item)
            }
        }
        var newOrder = a.order
        newOrder.replaceSubrange(startIndex ..< endIndex, with: addingItems)
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
                let i = random(0, path.order.count)
                let j = random(0, path.order.count)
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
