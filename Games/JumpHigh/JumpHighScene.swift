//
//  JumpHighScene.swift
//  Swift Alps Game Jam
//
//  Created by Florin Voicu on 23/11/2017.
//

import SpriteKit

private struct Categories {
    static let ground: UInt32 = 1
    static let flyingGround: UInt32 = 1 << 1
}

class JumpHighScene: SKScene {
    let player = SKSpriteNode(imageNamed: "Character")
    lazy var ground = makeGround()
    var flyingGrounds = [SKSpriteNode]()
    
    override func sceneDidLoad() {
        super.sceneDidLoad()
        
        ground.fillColor = .green
        ground.strokeColor = .green
        ground.physicsBody = SKPhysicsBody(rectangleOf: ground.frame.size, center: CGPoint(x: ground.frame.width / 2, y: ground.frame.height / 2))
        ground.physicsBody?.isDynamic = false
        ground.physicsBody?.categoryBitMask = Categories.ground
        addChild(ground)
        
        player.position.x = frame.midX
        player.position.y = 200
        player.scale(to: CGSize(width: player.size.width / 2, height: player.size.height / 2))
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody?.collisionBitMask = Categories.ground | Categories.flyingGround
        player.physicsBody?.contactTestBitMask = Categories.flyingGround
        player.physicsBody?.allowsRotation = false
        addChild(player)
        
        [1,3,5,7].forEach{spawnAirGround(heightLevel: $0)}
        
        physicsWorld.contactDelegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        let playerBody = player.physicsBody!
        let groundBody = ground.physicsBody!
        
        var touchingFlyingGround = false
        
        for flyingGround in flyingGrounds {
            if playerBody.allContactedBodies().contains(flyingGround.physicsBody!) {
                touchingFlyingGround = true
                break
            }
        }
        
        guard playerBody.allContactedBodies().contains(groundBody) || touchingFlyingGround else {
            return
        }
        
        playerBody.applyImpulse(CGVector(dx: 0, dy: 50))
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        for flyingGround in flyingGrounds {
            if player.physicsBody!.allContactedBodies().contains(flyingGround.physicsBody!) {
                if player.position.y > flyingGround.position.y + flyingGround.frame.size.height / 2 {
                    player.position.x = flyingGround.position.x
                }
                break
            }
        }
    }
    
    private func makeGround() -> SKShapeNode {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: 20)
        return SKShapeNode(rect: rect)
    }
    
    private func spawnAirGround(heightLevel: Int) {
        let random = arc4random() % 1000
        let delay = Double(random) / 1000.0
        
        Timer.scheduledTimer(withTimeInterval: 2 + TimeInterval(delay), repeats: true) { [weak self] _ in
            guard let scene = self else {
                return
            }
            
            let platformDirection = random / 500
            
            let ground = SKSpriteNode(imageNamed: "Platform-Single")
            ground.scale(to: CGSize(width: self!.player.frame.size.width * 1.4, height: self!.player.frame.size.width))
            ground.position.x = platformDirection % 2 == 0 ? -ground.frame.width : ground.frame.width + self!.size.width
            ground.position.y = (CGFloat(heightLevel) * (self!.player.frame.size.height)) * 1.5 + CGFloat(25 + arc4random() % 50)
            ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size)
            ground.physicsBody?.isDynamic = false
            ground.physicsBody?.categoryBitMask = Categories.flyingGround
            scene.addChild(ground)
            
            self?.flyingGrounds.append(ground)
            let moveTo = platformDirection % 2 == 0 ? scene.size.width + ground.frame.width : -ground.frame.width
            ground.run(.moveTo(x: moveTo, duration: 4)) {
                self?.flyingGrounds = self!.flyingGrounds.filter {$0 != ground}
                ground.removeFromParent()
            }
            
        }
        
    }
}

extension JumpHighScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        
    }
}

