//
//  GravityColliderScene.swift
//  Swift Alps Game Jam
//
//  Created by Dennis Charmington on 2017-11-23.
//
import SpriteKit

struct VolcanoCannonCategories {
    static let ground: UInt32 = 1
    static let coins: UInt32 = 1 << 1
    static let cannonBall: UInt32 = 1 << 2
}

class VolcanoCannonScene: SKScene {
    let houseLeft = SKSpriteNode(imageNamed: "House")
    let houseRight = SKSpriteNode(imageNamed: "House")
    
    var touchBegin:TimeInterval?
    
    var currentPlayer: SKSpriteNode!
    
    lazy var ground = makeGround()
    
    override func sceneDidLoad() {
        super.sceneDidLoad()
        createHouse(houseLeft, x: frame.minX + 40)
        createHouse(houseRight, x: frame.maxX - 40)
        
        currentPlayer = houseRight
        
        ground.fillColor = .green
        ground.strokeColor = .green
        ground.physicsBody = SKPhysicsBody(rectangleOf: ground.frame.size, center: CGPoint(x: ground.frame.width / 2, y: ground.frame.height / 2))
        ground.physicsBody?.isDynamic = false
        ground.physicsBody?.categoryBitMask = VolcanoCannonCategories.ground
        
        addChild(ground)
        let mountain = SKLabelNode(text: "🌋")
        mountain.setScale(3.0)
        mountain.position.x = frame.midX
        mountain.position.y = 30
        addChild(mountain)
        physicsWorld.contactDelegate = self
    }
    
    private func createHouse(_ house:SKSpriteNode, x:CGFloat) {
        house.position.x = x
        house.position.y = 20
        house.physicsBody = SKPhysicsBody(rectangleOf: house.size)
        
        house.physicsBody?.collisionBitMask = VolcanoCannonCategories.ground
        house.physicsBody?.contactTestBitMask = VolcanoCannonCategories.cannonBall
        
        
        addChild(house)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.touchBegin = event?.timestamp
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touchEnd = event?.timestamp, let touchBegin = self.touchBegin  else {
            return
        }
        let delta = touchEnd - touchBegin
        self.touchBegin = nil
        let isLeft = currentPlayer == houseLeft
        let multi :Double = isLeft ? 10 : -10
        shoot(from: currentPlayer.position, x: multi * delta, y: 50)
        
        currentPlayer = isLeft ? houseRight : houseLeft
    }
    
    private func makeGround() -> SKShapeNode {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: 30)
        return SKShapeNode(rect: rect)
    }
    
    private func shoot(from: CGPoint, x: Double, y: Double) {
        let cannonBall = SKLabelNode(text: "☄️")
        if x > 0 {
            cannonBall.xScale *= -1
        }
        cannonBall.physicsBody = SKPhysicsBody(rectangleOf: cannonBall.frame.size)
        cannonBall.position = CGPoint(x:from.x, y:from.y+50)
        cannonBall.physicsBody?.collisionBitMask = 0
        cannonBall.physicsBody?.categoryBitMask = VolcanoCannonCategories.cannonBall
        self.addChild(cannonBall)
        cannonBall.physicsBody?.applyImpulse(CGVector(dx: x, dy: 50))
        
    }
}

extension VolcanoCannonScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else {return}
        if  nodeA == houseLeft || nodeA == houseRight {
            let textures: [SKTexture] = [
                SKTexture(imageNamed: "Explosion-0"),
                SKTexture(imageNamed: "Explosion-1"),
                SKTexture(imageNamed: "Explosion-2"),
                SKTexture(imageNamed: "Explosion-3"),
                SKTexture(imageNamed: "Explosion-4"),
                SKTexture(imageNamed: "Explosion-5"),
                SKTexture(imageNamed: "Explosion-6")
            ]
            nodeA.run(.animate(with: textures, timePerFrame: 0.1, resize:true, restore:true)) {
                self.removeAllActions()
            }
            
        }
        
    }
}

