//  Created by Nikola Lajic on 11/23/17.
//  Copyright © 2017 ___ORGANIZATIONNAME___. All rights reserved.

import Foundation
import SpriteKit

private struct Categories {
    static let wall: UInt32 = 1
    static let platform: UInt32 = 1 << 1
}

class MoonLanderScene: SKScene {
    lazy var rocket: SKSpriteNode = {
        let node = SKSpriteNode(imageNamed: "Rocket")
        node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
        node.physicsBody?.angularDamping = 5
        node.physicsBody?.contactTestBitMask = Categories.wall
        return node
    }()
    lazy var platform: SKSpriteNode = {
        let platform = SKSpriteNode(imageNamed: "Platform-Single")
        platform.size = CGSize(width: platform.size.width * 3, height: platform.size.height)
        platform.physicsBody = SKPhysicsBody(rectangleOf: platform.frame.size)
        platform.physicsBody?.isDynamic = false
        platform.physicsBody?.contactTestBitMask = Categories.platform
        return platform
    }()
    let padding: CGFloat = 40
    let rotation: CGFloat = 0.01//1
    let boost: CGFloat = 40
    var left: SKLabelNode!
    var right: SKLabelNode!
    var fire: SKLabelNode!
    var win: SKLabelNode?
    
    override func sceneDidLoad() {
        super.sceneDidLoad()
        physicsWorld.gravity = CGVector(dx: 0, dy: -1)
        physicsWorld.contactDelegate = self
        
        addRocket()
        addPlatform()
        setupGUI()
        setupWalls()
    }
    
    func setupWalls() {
        let leftWall = SKShapeNode()
        leftWall.physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: 0, y: 0), to: CGPoint(x: 0, y: frame.maxY))
        leftWall.physicsBody?.contactTestBitMask = Categories.wall
        addChild(leftWall)
        
        let rightWall = SKShapeNode()
        rightWall.physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: frame.maxX, y: 0), to: CGPoint(x: frame.maxX, y: frame.maxY))
        rightWall.physicsBody?.contactTestBitMask = Categories.wall
        addChild(rightWall)
        
        let topWall = SKShapeNode()
        topWall.physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: 0, y: frame.maxY), to: CGPoint(x: frame.maxX, y: frame.maxY))
        topWall.physicsBody?.contactTestBitMask = Categories.wall
        addChild(topWall)
        
        let bottomWall = SKShapeNode()
        bottomWall.physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: 0, y: 0), to: CGPoint(x: frame.maxX, y: 0))
        bottomWall.physicsBody?.contactTestBitMask = Categories.wall
        addChild(bottomWall)
    }
    
    func addPlatform() {
        let x: CGFloat = platform.size.width + CGFloat(arc4random_uniform(UInt32(frame.maxX - platform.size.width * 2)))
        platform.position = CGPoint(x: x, y: 120)
        addChild(platform)
    }
    
    func addRocket() {
        if rocket.parent == nil {
            let x: CGFloat = rocket.size.width + CGFloat(arc4random_uniform(UInt32(frame.maxX - rocket.size.width * 2)))
            rocket.position = CGPoint(x: x, y: frame.maxY - rocket.size.height)
            rocket.zRotation = 0
            addChild(rocket)
        }
    }
    
    func setupGUI() {
        let background = SKShapeNode(rect: CGRect(x: 0, y: 0, width: frame.width, height: 100))
        background.fillColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        background.strokeColor = UIColor.clear
        addChild(background)
        
        left = SKLabelNode(text: "◀︎")
        left.color = UIColor.white
        left.position = CGPoint(x: frame.minX + padding, y: padding)
        addChild(left)
        
        right = SKLabelNode(text: "▶︎")
        right.color = UIColor.white
        right.position = CGPoint(x: frame.maxX - padding, y: padding)
        addChild(right)
        
        fire = SKLabelNode(text: "🔥")
        fire.position = CGPoint(x: frame.midX, y: padding)
        addChild(fire)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if win != nil {
            restart()
            return
        }
        
        guard let touchLocation = touches.first?.location(in: self) else { return }
        
        if left.frame.insetBy(dx: -padding, dy: -padding).contains(touchLocation) {
            rocket.physicsBody?.applyAngularImpulse(rotation)
        }
        else if right.frame.insetBy(dx: -padding, dy: -padding).contains(touchLocation) {
            rocket.physicsBody?.applyAngularImpulse(-rotation)
        }
        else if fire.frame.insetBy(dx: -padding, dy: -padding).contains(touchLocation) {
            let rotation = rocket.zRotation + (CGFloat.pi / 2.0)
            let newVec = CGVector(dx: boost * cos(rotation), dy: boost * sin(rotation))
            rocket.physicsBody?.applyImpulse(newVec)
        }
    }
    
    func restart() {
        win?.removeFromParent()
        win = nil
        rocket.removeFromParent()
        addRocket()
        platform.removeFromParent()
        addPlatform()
    }
}

extension MoonLanderScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        if win != nil {
            return
        }
        if contact.bodyB.contactTestBitMask & Categories.platform != 0 {
            if contact.collisionImpulse > 40 {
                restart()
            }
            else {
                win = SKLabelNode(text: "YOU WON!")
                win?.position = CGPoint(x: frame.midX, y: frame.midY)
                addChild(win!)
            }
        }
        else {
            restart()
        }
    }
    
}

