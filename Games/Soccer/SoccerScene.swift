//
//  SoccerScene.swift
//  Swift Alps Game Jam
//
//  Created by Sameh Mabrouk on 23/11/2017.
//

import SpriteKit

private struct Categories {
    static let ground: UInt32 = 1
    static let ball: UInt32 = 1 << 1
    static let player: UInt32 = 1 << 2
}

class SoccerScene: SKScene {
    let player = SKSpriteNode(imageNamed: "Character-Front-0")
    lazy var ground = makeGround()
    var ballCount = 10
    private lazy var scoreLabel = SKLabelNode()
    var gameScore = 0
    
    override func sceneDidLoad() {
        super.sceneDidLoad()
        
        physicsWorld.contactDelegate = self
        
        ground.fillColor = .green
        ground.strokeColor = .green
        ground.physicsBody = SKPhysicsBody(rectangleOf: ground.frame.size, center: CGPoint(x: ground.frame.width / 2, y: ground.frame.height / 2))
        ground.physicsBody?.isDynamic = false
        ground.physicsBody?.categoryBitMask = Categories.ground
        
        addChild(ground)
        
        player.position.x = frame.midX
        player.position.y = 200
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody?.contactTestBitMask = Categories.ball
        player.physicsBody?.mass = 0.3
        addChild(player)
        
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { [weak self] _ in
            guard let  strongSelf = self else {
                return
            }
            
            if strongSelf.ballCount > 1 {
                strongSelf.createBall()
            }
        }
        
        // We setup the score label here, since now the view's safe area insets are known
        scoreLabel.position.x = scene!.frame.size.width - 100
        scoreLabel.position.y = scene!.frame.size.height - 20
        scoreLabel.fontSize = 25
        scoreLabel.fontColor = UIColor.white
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.text = "Score: \(gameScore)"
        addChild(scoreLabel)
    }
    
    func createBall() {
        let ball = SKSpriteNode(imageNamed: "SoccerBall")
        
        ball.setScale(2)
        ball.physicsBody?.mass = 0.09
        ball.position.x = randomXPosition()
        ball.position.y = scene!.frame.height
        ball.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 50, height: 50))
        ball.physicsBody?.categoryBitMask = Categories.ball
        ground.physicsBody?.contactTestBitMask = Categories.ball
        
        addChild(ball)
        
        physicsWorld.gravity.dy = -2
        
        let playerBody = ball.physicsBody!
        playerBody.allowsRotation = false
        
        ballCount -= 1
    }
    
    // This is called when the scene has moved to its view
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        let playerBody = player.physicsBody!
        let groundBody = ground.physicsBody!
        
        guard playerBody.allContactedBodies().contains(groundBody) else {
            return
        }
        
        playerBody.applyImpulse(CGVector(dx: 0, dy: 100))
        playerBody.allowsRotation = false
        let x = touches.first!.location(in: self).x
        player.run(.moveTo(x: x, duration: 1))
        
    }
    
    private func makeGround() -> SKShapeNode {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: 70)
        return SKShapeNode(rect: rect)
    }
}

extension SoccerScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        
        if gameScore == 3 {
            let myLabel = SKLabelNode(fontNamed:"Chalkduster")
            myLabel.text = "GameOver!"
            myLabel.fontSize = 65
            myLabel.position = CGPoint(x: frame.midX, y: frame.midY)
            self.addChild(myLabel)
        }
        
        gameScore += 1
        scoreLabel.text = "Score : \(gameScore)"
        
        if contact.bodyA.node == player {
            contact.bodyB.node?.removeFromParent()
        } else {
            contact.bodyA.node?.removeFromParent()
        }
    }
}
