import SpriteKit
import PlaygroundSupport

struct Categories {
    static let ground: UInt32 = 1
    static let enemy: UInt32 = 1 << 1
}

class Scene: SKScene {
    let player = SKSpriteNode(imageNamed: "Character")
    let fire = SKSpriteNode(imageNamed: "Explosion-0")
    lazy var ground = makeGround()
    var score = 0
    let scoreLabel = SKLabelNode(text: "Score:")
    
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
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody?.collisionBitMask = Categories.ground
        addChild(player)
        
        createFire()
        
        scoreLabel.position.x = 100
        scoreLabel.position.y = 600
        scoreLabel.text = "Score: \(score)"
        addChild(scoreLabel)


        Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { [weak self] _ in
            guard let scene = self else {
                return
            }

            let enemy = SKSpriteNode(imageNamed: "Character")
            enemy.position.x = -enemy.frame.width
            enemy.position.y = 300
            enemy.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 50, height: 50))
            enemy.physicsBody?.isDynamic = false
            enemy.physicsBody?.categoryBitMask = Categories.enemy
            scene.addChild(enemy)

            enemy.run(.moveTo(x: scene.size.width + enemy.frame.width, duration: 3)) {
                enemy.removeFromParent()
            }
        }

        physicsWorld.contactDelegate = self

        
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        fire.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 200))
    }

    private func makeGround() -> SKShapeNode {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: 100)
        return SKShapeNode(rect: rect)
    }
    
    func createFire() {
        fire.position.x = frame.midX
        fire.position.y = 220
        fire.physicsBody = SKPhysicsBody(rectangleOf: fire.size)
        fire.physicsBody?.contactTestBitMask = Categories.enemy
        fire.physicsBody?.collisionBitMask = Categories.ground
        addChild(fire)
    }

}

extension Scene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.node == fire {
            if contact.bodyB.node != player {
            contact.bodyB.node?.removeFromParent()
                updateScore()
                explode()
            }
        } else {
            if contact.bodyA.node != player {
                contact.bodyA.node?.removeFromParent()
                updateScore()
                explode()
            }
        }
    }
    
    func updateScore() {
        score += 1
        scoreLabel.text = "Score: \(score)"
    }
    
    func explode() {
        let textures: [SKTexture] = [
            SKTexture(imageNamed: "Explosion-0"),
            SKTexture(imageNamed: "Explosion-1"),
            SKTexture(imageNamed: "Explosion-2"),
            SKTexture(imageNamed: "Explosion-3"),
            SKTexture(imageNamed: "Explosion-4"),
            SKTexture(imageNamed: "Explosion-5"),
            SKTexture(imageNamed: "Explosion-6"),
            SKTexture(imageNamed: "Explosion-0")
        ]
        fire.run(.animate(with: textures, timePerFrame: 0.05)) {
            self.fire.removeFromParent()
            
        }
        self.fire.physicsBody = nil
    }

}

let viewFrame = CGRect(x: 0, y: 0, width: 365, height: 667)
let view = SKView(frame: viewFrame)
view.presentScene(Scene(size: viewFrame.size))
PlaygroundPage.current.liveView = view
