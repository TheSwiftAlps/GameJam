//
//  GravityColliderScene.swift
//  Swift Alps Game Jam
//
//  Created by Dennis Charmington on 2017-11-23.
//
import SpriteKit

private struct Categories {
    static let ground: UInt32 = 1
    static let coins: UInt32 = 1 << 1
}

class GravityColliderScene: SKScene {
    let player = SKLabelNode(text: "🤠")
    
    let pointLabel = SKLabelNode(text: "DAMAGE: 0")
    var damage = 0
    lazy var fence = makeFence()
    
    override func sceneDidLoad() {
        super.sceneDidLoad()
        
        physicsWorld.gravity.dy = 0
        physicsWorld.gravity.dx = 0
        
        fence.forEach { (node) in
            addChild(node)
        }
        
        pointLabel.position.x = frame.midX
        pointLabel.position.y = frame.height - 50 - 44
        addChild(pointLabel)
        
        player.position.x = frame.midX
        player.position.y = frame.midY
        player.fontSize = 60.0
        
        var playerHitFrame = player.frame.size
        playerHitFrame.width -= 5
        playerHitFrame.height -= 7
        player.physicsBody = SKPhysicsBody(rectangleOf: playerHitFrame,
                                           center: CGPoint(x: 0,
                                                           y: player.fontSize / 2 - 8))
        player.physicsBody?.collisionBitMask = Categories.ground
        player.physicsBody?.contactTestBitMask = Categories.ground
        addChild(player)
        
        arc4random_stir()
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let scene = self else {
                return
            }
            
            scene.physicsWorld.gravity.dy = CGFloat(arc4random_uniform(3)) - 1.2
            
            scene.physicsWorld.gravity.dx = CGFloat(arc4random_uniform(3)) - 1.2
        }
        
        physicsWorld.contactDelegate = self
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        let pos = touches.first!.location(in: self)
        
        let multiplier: CGFloat = 0.2
        
        let diff_x: CGFloat = (pos.x - player.position.x) * multiplier
        let diff_y: CGFloat = (pos.y - player.position.y) * multiplier
        
        player.physicsBody?.applyImpulse(CGVector(dx: diff_x, dy: diff_y))
        
    }
    
    
    
    private func makeFence() -> [SKShapeNode] {
        let bottomFrame = CGRect(x: 0, y:0, width: size.width, height: 10)
        let bottomNode = SKShapeNode(rect: bottomFrame)
        
        bottomNode.fillColor = .red
        bottomNode.strokeColor = .red
        bottomNode.physicsBody = SKPhysicsBody(edgeLoopFrom: bottomFrame)
        
        bottomNode.physicsBody?.isDynamic = false
        bottomNode.physicsBody?.categoryBitMask = Categories.ground
        
        let topFrame = CGRect(x: 0, y:size.height-10-44, width: size.width, height: 10)
        let topNode = SKShapeNode(rect: topFrame)
        
        topNode.fillColor = .red
        topNode.strokeColor = .red
        topNode.physicsBody = SKPhysicsBody(edgeLoopFrom: topFrame)
        
        topNode.physicsBody?.isDynamic = false
        topNode.physicsBody?.categoryBitMask = Categories.ground
        
        let leftFrame = CGRect(x: 0, y:0, width: 10, height: size.height)
        let leftNode = SKShapeNode(rect: leftFrame)
        
        leftNode.fillColor = .red
        leftNode.strokeColor = .red
        leftNode.physicsBody = SKPhysicsBody(edgeLoopFrom: leftFrame)
        
        leftNode.physicsBody?.isDynamic = false
        leftNode.physicsBody?.categoryBitMask = Categories.ground
        
        
        let rigthFrame = CGRect(x: size.width-10, y:0, width: 10, height: size.height)
        let rightNode = SKShapeNode(rect: rigthFrame)
        
        rightNode.fillColor = .red
        rightNode.strokeColor = .red
        rightNode.physicsBody = SKPhysicsBody(edgeLoopFrom: rigthFrame)
        
        rightNode.physicsBody?.isDynamic = false
        rightNode.physicsBody?.categoryBitMask = Categories.ground
        
        return [bottomNode, topNode, leftNode, rightNode]
    }
}

extension GravityColliderScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        damage += 1
        pointLabel.text = "DAMAGE: \(damage)"
        
        let multiplier: CGFloat = 0.1
        
        let diff_x: CGFloat = (frame.midX - player.position.x) * multiplier
        let diff_y: CGFloat = (frame.midY - player.position.y) * multiplier
        
        player.physicsBody?.applyImpulse(CGVector(dx: diff_x, dy: diff_y))
        
        switch damage {
        case 5...7: player.text = "😕"
        case 8...10: player.text = "😩"
        case 11...13: player.text = "😭"
        case 14...16: player.text = "🤯"
        case 17...18: player.text = "🤬"
        case 19...20: player.text = "💩"
        case 21...30: player.text = "🔥"
            
        default: break
        }
    }
}

