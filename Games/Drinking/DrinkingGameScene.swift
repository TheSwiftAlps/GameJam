//
//  DrinkingGameScene.swift
//  Swift Alps Game Jam
//
//  Created by Sidney de Koning on 23/11/2017.
//

import SpriteKit

private struct Categories {
    static let ground: UInt32 = 1
    static let coins: UInt32 = 1 << 1
}

class DrinkingGameScene: SKScene {
    let player = SKSpriteNode(imageNamed: "Character-Front-0")
    lazy var ground = makeGround()
    
    let scoreLabel = SKLabelNode(text: "0")
    let goHomeLabel = SKLabelNode(text: "🕺🏻")
    
    var score: Int = 0
    var shouldGoHome: Bool = false
    
    override func sceneDidLoad() {
        super.sceneDidLoad()
        
        ground.fillColor = .brown
        ground.strokeColor = .brown
        ground.physicsBody = SKPhysicsBody(rectangleOf: ground.frame.size, center: CGPoint(x: ground.frame.width / 2, y: ground.frame.height / 2))
        ground.physicsBody?.isDynamic = false
        ground.physicsBody?.categoryBitMask = Categories.ground
        addChild(ground)
        
        player.position.x = frame.midX
        player.position.y = 200
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody?.collisionBitMask = Categories.ground
        player.physicsBody?.contactTestBitMask = Categories.coins
        addChild(player)
        
        self.addScoreLabel()
        
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            
            let randomScale = CGFloat(arc4random_uniform(4))
            let randomPosition = CGFloat(arc4random_uniform(UInt32(self?.frame.width ?? 0)))
            
            guard self?.shouldGoHome == false else { return }
            self?.letItRain(scale: randomScale, position: randomPosition)
        }
        
        physicsWorld.contactDelegate = self
    }
    
    func addScoreLabel() {
        
        self.scoreLabel.position.x = self.frame.midX
        self.scoreLabel.position.y = 20
        
        self.addChild(self.scoreLabel)
    }
    
    func letItRain(scale: CGFloat, position: CGFloat) {
        
        let drinks = ["🍺","🍻","🥂","🍷","🍸","🍾","🥃","🍸","🍹"]
        let randomDrink = Int(arc4random_uniform(UInt32(drinks.count)))
        
        let drink = SKLabelNode(text: drinks[randomDrink])
        drink.setScale(scale)
        drink.verticalAlignmentMode = .center
        drink.position.x = position
        drink.position.y = self.frame.height
        drink.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 50, height: 50))
        drink.physicsBody?.isDynamic = false
        drink.physicsBody?.categoryBitMask = Categories.coins
        self.addChild(drink)
        
        drink.run(.moveTo(y: 0 - drink.frame.height, duration: 15 / Double(self.score + 1))) {
            drink.removeFromParent()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        guard let touchPoint = touches.first?.location(in: self) else { return }
        
        player.run(.move(to: touchPoint, duration: 0.5))
        
    }
    
    private func makeGround() -> SKShapeNode {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: 100)
        return SKShapeNode(rect: rect)
    }
}

extension DrinkingGameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.node == player {
            contact.bodyB.node?.removeFromParent()
            
            self.addScore()
        } else {
            contact.bodyA.node?.removeFromParent()
            self.addScore()
        }
    }
    
    func addScore() {
        self.score = self.score + 1
        self.scoreLabel.text = self.score.description
        
        self.goHome()
    }
    
    func goHome() {
        
        player.physicsBody?.allowsRotation = true
        
        if self.score > 30 {
            
            self.shouldGoHome = true
            
            self.goHomeLabel.position.x = self.frame.midX
            self.goHomeLabel.position.y = self.frame.midY
            self.goHomeLabel.fontSize = 140
            self.scoreLabel.text = "You are drunk, go dancing!"
            
            if self.goHomeLabel.parent == nil {
                self.addChild(self.goHomeLabel)
                self.player.removeFromParent()
            }
            
            // add label + add click to restart
        } else {
            
            
        }
    }
}
