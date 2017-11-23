//
//  DeathStarScene.swift
//  Swift Alps Game Jam
//
//  Created by Eran Jalink on 23/11/2017.
//

import Foundation
import SpriteKit

private struct Categories {
    static let rocket: UInt32 = 1
    static let enemy: UInt32 = 1 << 1
}

class DeathStarScene: SKScene {
    
    //MARK: Objects
    lazy var deathStar: SKSpriteNode = {
        let deathStar = SKSpriteNode(imageNamed: "Character-Front-0")
        deathStar.position.x = frame.midX
        deathStar.position.y = frame.midY
        
        return deathStar
    }()
    
    func makeRocket() {
        let rocket = SKSpriteNode(imageNamed: "Rocket")
        rocket.position.x = frame.midX
        rocket.position.y = frame.midY
        rocket.zRotation = deathStar.zRotation
        rocket.physicsBody = SKPhysicsBody(rectangleOf: rocket.size)
        rocket.physicsBody?.categoryBitMask = Categories.rocket
        rocket.physicsBody?.contactTestBitMask = Categories.enemy
        rocket.physicsBody?.collisionBitMask = 0
        addChild(rocket)
        fireRocket(rocket)
    }
    
    func makeEnemy() {
        let enemy = SKSpriteNode(imageNamed: "Asteroid")
        enemy.scale(to: CGSize(width: 30, height: 30))
        enemy.position = createRandomCoordinate()
        enemy.run(rotateForever())
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
        enemy.physicsBody?.categoryBitMask = Categories.enemy
        enemy.physicsBody?.contactTestBitMask = Categories.rocket
        
        addChild(enemy)
        moveEnemy(enemy)
    }
    
    func createRandomCoordinate() -> CGPoint {
        let x: CGFloat
        let y: CGFloat
        
        let topOrBottom = arc4random_uniform(2) == 0
        
        if topOrBottom {
            x = randomXPosition()
            if arc4random_uniform(2) == 0 {
                y = 0
            } else {
                y = frame.height
            }
        } else {
            y = randomYPosition()
            if arc4random_uniform(2) == 0 {
                x = 0
            } else {
                x = frame.width
            }
        }
        
        return CGPoint(x: x, y: y)
    }
    
    //MARK: Animation
    private func rotateForever() -> SKAction {
        let oneRevolution = SKAction.rotate(byAngle: CGFloat(-Double.pi * 2), duration: 5.0)
        let repeated = SKAction.repeatForever(oneRevolution)
        
        return repeated
    }
    
    private func fireRocket(_ rocket: SKSpriteNode) {
        let r: CGFloat = 50
        
        let radianFactor:CGFloat = 0.0174532925;
        let rotationInDegrees = rocket.zRotation / radianFactor;
        let newRotationDegrees = rotationInDegrees + 90;
        let newRotationRadians = newRotationDegrees * radianFactor;
        
        
        let dx = r * cos(newRotationRadians)
        let dy = r * sin(newRotationRadians)
        // Specify the force to apply to the SKPhysicsBody
        rocket.physicsBody?.applyImpulse(CGVector(dx: dx, dy: dy))
    }
    
    private func moveEnemy(_ enemy: SKSpriteNode) {
        let moveToCenter = SKAction.move(to: center, duration: 10)
        enemy.run(moveToCenter)
    }
    
    override func sceneDidLoad() {
        super.sceneDidLoad()
        
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        
        addChild(deathStar)
        deathStar.run(rotateForever())
        
        physicsWorld.contactDelegate = self
        
        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true, block: { [weak self] _ in
            self?.makeEnemy()
            
        })
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        makeRocket()
    }
}

extension DeathStarScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        print(contact)
        let enemyBody: SKPhysicsBody
        let rocketBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask == Categories.enemy {
            enemyBody = contact.bodyA
            rocketBody = contact.bodyB
        } else {
            enemyBody = contact.bodyB
            rocketBody = contact.bodyA
        }
        
        let textures: [SKTexture] = [
            SKTexture(imageNamed: "Explosion-0"),
            SKTexture(imageNamed: "Explosion-1"),
            SKTexture(imageNamed: "Explosion-2"),
            SKTexture(imageNamed: "Explosion-3"),
            SKTexture(imageNamed: "Explosion-4"),
            SKTexture(imageNamed: "Explosion-5"),
            SKTexture(imageNamed: "Explosion-6")
        ]
        let enemy = enemyBody.node
        let rocket = rocketBody.node
        
        enemy?.run(.animate(with: textures, timePerFrame: 0.05)) {
            enemy?.removeFromParent()
            rocket?.removeFromParent()
        }
    }
}

