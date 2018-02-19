//
//  GameScene.swift
//  CC035-Traveling Salesperson
//
//  Created by Bob Voorneveld on 19-02-18.
//  Copyright © 2018 Bob Voorneveld. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var spinnyNode : SKShapeNode?
    private var nodes = [SKShapeNode]()
    
    private lazy var formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.usesSignificantDigits = true
        return formatter
    }()
    
    private var path: SKShapeNode?
    private var shortestDistance = Double(Int.max)
    private var shortestPath: SKShapeNode?
    private var distanceNode: SKLabelNode!
    
    private var arrangement = [Int]()
    private var possibilities = 0
    private var possibilityNumber = 0

    override func didMove(to view: SKView) {
        
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.01
        spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        spinnyNode!.lineWidth = 2.5
        spinnyNode!.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
        
        distanceNode = SKLabelNode(text: "0")
        distanceNode.position = CGPoint(x: -size.width / 2, y: -size.height / 2)
        distanceNode.horizontalAlignmentMode = .left
        distanceNode.verticalAlignmentMode = .bottom
        addChild(distanceNode!)
    }

    override func mouseUp(with event: NSEvent) {
        let pos = event.location(in: self)
        if let n = spinnyNode?.copy() as! SKShapeNode? {
            shortestDistance = Double(Int.max)
            shortestPath?.removeFromParent()
            n.position = pos
            if nodes.count == 0 {
            n.strokeColor = .red
            } else {
                n.strokeColor = .blue
            }
            addChild(n)
            nodes.append(n)
            arrangement.append(arrangement.count)
            arrangement.sort()
            createPath(from: newOrderNodes())
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
//        let random = nodes.shuffled()
//        createPath(from: random)
        if let lexical = nextLexicographicalOrder() {
            createPath(from: lexical)
        }
    }
    
    override func keyDown(with event: NSEvent) {
        if event.keyCode == 0x31 {
            reset()
            print("spacebar")
        }
    }
    
    private func reset() {
        nodes.forEach({$0.removeFromParent()})
        nodes.removeAll()
        path?.removeFromParent()
        shortestPath?.removeFromParent()
        shortestDistance = Double(Int.max)
        distanceNode.text = "0"
        arrangement = [Int]()
    }
    
    private func createPath(from nodes: [SKShapeNode]) {
        guard nodes.count > 1 else {
            return
        }
        var points = nodes.map { $0.position }
        let distance = calcDistance(points)
        
        path?.removeFromParent()
        path = SKShapeNode(points: &points, count: points.count)
        addChild(path!)

        if distance < shortestDistance {
            newShortestDistance(distance: distance, path: path!)
        }
    }
    
    private func calcDistance(_ points: [CGPoint]) -> Double {
        var distance = 0.0
        
        for i in 1 ..< points.count {
            let xDist = Double(points[i - 1].x) - Double(points[i].x)
            let yDist = Double(points[i - 1].y) - Double(points[i].y)
            distance += Double(sqrt((xDist * xDist) + (yDist * yDist)))
        }
        return distance
    }
    
    private func newShortestDistance(distance: Double, path: SKShapeNode) {
        distanceNode.text = formatter.string(from: distance as NSNumber)
        shortestDistance = distance
        shortestPath?.removeFromParent()
        shortestPath = path.copy() as? SKShapeNode
        shortestPath?.strokeColor = .green
        shortestPath?.lineWidth = 4
        shortestPath?.zPosition = 2
        addChild(shortestPath!)
    }
    
    private func nextLexicographicalOrder() -> [SKShapeNode]? {
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
        var newOrderNodes = [SKShapeNode]()
        for index in arrangement {
            newOrderNodes.append(nodes[index])
        }
        return newOrderNodes
    }
}

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
