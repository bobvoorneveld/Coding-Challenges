//
//  GameScene.swift
//  CC035-Traveling Salesperson
//
//  Created by Bob Voorneveld on 19-02-18.
//  Copyright © 2018 Bob Voorneveld. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    enum Mode {
        case random
        case lexical
        case genetic
    }
    
    private var currentMode: Mode = .genetic
    private var startingPoints = 50

    private var distanceNode: SKLabelNode!
    private var nodeSizeNode: SKLabelNode!
    private var infoNode: SKLabelNode!

    private var spinnyNode : SKShapeNode?
    var nodes = [SKShapeNode]()
    
    private lazy var formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.usesSignificantDigits = true
        return formatter
    }()
    
    private var shortestPath: SKShapeNode?
    var shortestDistance = Double(Int.max)

    private var shortestDistanceForGeneration = Double(Int.max)
    private var bestPathForGeneration: SKShapeNode?
    
    // Lexical
    var arrangement = [Int]()
    var count = 0
    
    // Genetic
    var population = [Path]()
    var lookup = [Int: Double]()
    var generation = 0
    var bestPath: Path?

    override func didMove(to view: SKView) {
        anchorPoint = CGPoint(x: 0, y: 0)
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.01
        spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        spinnyNode!.lineWidth = 2.5
        spinnyNode!.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
        

        nodeSizeNode = SKLabelNode(text: "Cities: 0")
        nodeSizeNode.position = CGPoint(x: 0, y: size.height)
        nodeSizeNode.horizontalAlignmentMode = .left
        nodeSizeNode.verticalAlignmentMode = .top
        addChild(nodeSizeNode!)

        distanceNode = SKLabelNode(text: "Distance: 0")
        distanceNode.position = CGPoint(x: 0, y: size.height - nodeSizeNode.frame.height)
        distanceNode.horizontalAlignmentMode = .left
        distanceNode.verticalAlignmentMode = .top
        addChild(distanceNode!)

        infoNode = SKLabelNode(text: "")
        infoNode.position = CGPoint(x: 0, y: size.height - nodeSizeNode.frame.height - distanceNode.frame.height)
        infoNode.horizontalAlignmentMode = .left
        infoNode.verticalAlignmentMode = .top
        addChild(infoNode!)
        
        addRandomPoints()
    }

    override func mouseUp(with event: NSEvent) {
        let pos = event.location(in: self)
        addNode(at: pos)
    }
    
    func addRandomPoints() {
        for _ in 0 ..< startingPoints {
            var location: CGPoint = .zero
            while true {
                location = CGPoint(x: random(size.width), y: size.height / 2 + random(size.height / 2))
                if !(location.y > infoNode.frame.minY && location.x < distanceNode.frame.maxX) {
                    break
                }
            }
            addNode(at: location)
        }
    }
    
    func addNode(at position: CGPoint) {
        guard let n = spinnyNode?.copy() as! SKShapeNode? else {
            return
        }
        shortestDistance = Double(Int.max)
        shortestPath?.removeFromParent()
        n.position = position
        if nodes.count == 0 {
            n.strokeColor = .red
        } else {
            n.strokeColor = .blue
        }
        addChild(n)
        nodes.append(n)
        nodeSizeNode.text = "Cities: \(nodes.count)"
        infoNode.text = "Generation: 0"
        
        
        switch currentMode {
        case .genetic:
            createNewPopulation()
            generation = 0
        case .lexical:
            // Reset the arrangement
            arrangement = [Int](0 ..< nodes.count)
            count = 0
        default: break
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        let prevDistance = shortestDistance
        shortestDistanceForGeneration = Double(Int.max)
        bestPathForGeneration?.removeFromParent()
        
        switch currentMode {
        case .random:
            if nodes.count > 2 {
                var random = nodes[1...].shuffled()
                random.insert(nodes[0], at: 0)
                nodes = random
            }
            createPath(from: nodes)
        case .lexical:
            if let lexical = nextLexicographicalOrder() {
                count += 1
                infoNode.text = "Possibilities tried: \(count + 1) / \(factorial(nodes.count - 1))"
                createPath(from: lexical)
            }
        case .genetic:
            generation += 1
            normalizePopulation()
            nextGeneration()
            infoNode.text = "Generation: \(generation)"
        }
        
        if let bestPathG = bestPathForGeneration {
            bestPathG.position = CGPoint(x: bestPathG.position.x, y: bestPathG.position.y - size.height / 2)
        }
        if prevDistance > shortestDistance {
            backgroundColor = .darkGray
        } else {
            backgroundColor = .black
        }
    }
    
    override func keyDown(with event: NSEvent) {
        if event.keyCode == 0x31 {
            reset()
        }
    }
    
    private func reset() {
        distanceNode.text = "Distance: 0"
        nodeSizeNode.text = "Cities: 0"
        infoNode.text = ""

        nodes.forEach({$0.removeFromParent()})
        nodes.removeAll()

        shortestPath?.removeFromParent()
        shortestDistance = Double(Int.max)
        bestPathForGeneration?.removeFromParent()
        
        arrangement = [Int]()
        
        population.removeAll(keepingCapacity: true)
        lookup.removeAll()
        
        addRandomPoints()
    }
    
    @discardableResult
    func createPath(from nodes: [SKShapeNode]) -> Double? {
        guard nodes.count > 1 else {
            return nil
        }
        let distance = calcDistance(nodes)
        
        if distance < shortestDistanceForGeneration {
            var points = nodes.map { $0.position }
            shortestDistanceForGeneration = distance
            bestPathForGeneration?.removeFromParent()
            bestPathForGeneration = SKShapeNode(points: &points, count: points.count)
            addChild(bestPathForGeneration!)
        }

        if distance < shortestDistance {
            var points = nodes.map { $0.position }
            points.append(nodes[0].position)
            newShortestDistance(distance: distance, points: points)
        }
        return distance
    }
    
    private func calcDistance(_ nodes: [SKShapeNode]) -> Double {
        var distance = 0.0
        
        for i in 1 ..< nodes.count {
            let nodeA = nodes[i]
            let nodeB = nodes[(i + 1) % nodes.count]
            let hash = (nodeA.hashValue << 5) &+ nodeA.hashValue &+ nodeB.hashValue
            if let nodeDistance = lookup[hash] {
                distance += nodeDistance
            } else {
                let xDist = Double(nodeA.position.x) - Double(nodeB.position.x)
                let yDist = Double(nodeA.position.y) - Double(nodeB.position.y)
                let newDistance = Double(sqrt((xDist * xDist) + (yDist * yDist)))
                lookup[hash] = newDistance
                distance += newDistance
            }
        }
        return distance
    }
    
    private func newShortestDistance(distance: Double, points: [CGPoint]) {
        var points = points
        distanceNode.text = "Distance: \(formatter.string(from: distance as NSNumber)!)"
        shortestDistance = distance
        shortestPath?.removeFromParent()
        shortestPath = SKShapeNode(points: &points, count: points.count)
        shortestPath?.strokeColor = .green
        shortestPath?.lineWidth = 4
        shortestPath?.zPosition = 2
        addChild(shortestPath!)
    }
}
