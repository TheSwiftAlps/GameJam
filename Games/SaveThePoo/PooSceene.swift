//
//  PooSceene.swift
//  Swift Alps Game Jam
//
//  Created by Askia Linder on 2017-11-23.
//
import Foundation
import SpriteKit

struct PooCategories {
    static let player: UInt32 = 1
    static let paper: UInt32 = 1 << 1
}

class PooScene: SKScene {
    let player = SKLabelNode(text: "💩")
    let rightButton = SKLabelNode(text: "➡️")
    let leftButton = SKLabelNode(text: "⬅️")
    
    var healthPoints = SKLabelNode(text: "❤️❤️❤️")
    
    override func sceneDidLoad() {
        super.sceneDidLoad()
        
        leftButton.position.y = 15
        leftButton.position.x = 60
        leftButton.setScale(3)
        leftButton.name = "leftButton"
        addChild(leftButton)
        
        rightButton.position.y = 15
        rightButton.position.x = frame.width - 60
        rightButton.setScale(3)
        rightButton.name = "rightButton"
        
        addChild(rightButton)
        
        player.setScale(2)
        
        player.position.x = frame.midX
        player.position.y = 200
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.fontSize, center: CGPoint(x: 0, y: 20))
        player.physicsBody?.contactTestBitMask = PooCategories.paper
        player.physicsBody?.isDynamic = false
        
        addChild(player)
        
        
        healthPoints.position.x = frame.width - 100
        healthPoints.position.y = frame.height - 80
        addChild(healthPoints)
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let scene = self else {
                return
            }
            
            let money = SKLabelNode(text: "🗞")
            money.setScale(2)
            money.verticalAlignmentMode = .center
            money.position.x = CGFloat(arc4random_uniform(UInt32(scene.frame.width)))
            money.position.y = scene.frame.height
            money.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 50, height: 50))
            money.physicsBody?.affectedByGravity = false
            money.physicsBody?.categoryBitMask = PooCategories.paper
            scene.addChild(money)
            
            money.run(.moveTo(y: 0, duration: 8)) {
                money.removeFromParent()
            }
        }
        
        physicsWorld.contactDelegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        let touch = touches.first! as UITouch
        let postionInScene = touch.location(in: self)
        let touchNode = self.nodes(at: postionInScene).first! as SKNode
        
        if let name = touchNode.name {
            if name == "rightButton" {
                player.position.x = player.position.x + 10
            } else if name == "leftButton" {
                player.position.x = player.position.x - 10
            }
        }
    }
    
    private func makeGround() -> SKShapeNode {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: 100)
        return SKShapeNode(rect: rect)
    }
}

extension PooScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.node == player {
            contact.bodyB.node?.removeFromParent()
        } else {
            contact.bodyA.node?.removeFromParent()
        }
        
        switch healthPoints.text!.characters.count {
        case 1: healthPoints.text = "Game Over"
        case 2: healthPoints.text = "❤️"
        case 3: healthPoints.text = "❤️❤️"
        default: healthPoints.text = "❤️❤️❤️"
        }
        
    }
}

