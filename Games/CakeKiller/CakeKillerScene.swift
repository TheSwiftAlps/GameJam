import SpriteKit

class CakeKillerScene: SKScene {
    let cake = SKLabelNode(text: "🍰")
    var knifes = Set<SKLabelNode>()
    
    var enemy: SKLabelNode {
        let label = SKLabelNode(text: "🍏")
        label.setScale(2)
        return label
    }
    
    override func sceneDidLoad() {
        super.sceneDidLoad()
        
        cake.setScale(3)
        cake.position.x = self.frame.midX
        cake.position.y = 50
        let physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: cake.frame.size.width, height: cake.frame.size.height ))
        cake.physicsBody = physicsBody
        cake.physicsBody?.isDynamic = false
        cake.physicsBody?.contactTestBitMask = 1
        addChild(cake)
        
        // Spawn a new emoji every 0.5 seconds
        run(
            .repeatForever(
                .sequence([
                    .wait(forDuration: 0.5),
                    .run({ [weak self] in
                        self?.spawnVegetable()
                    })
                    ])
            )
        )
        
        physicsWorld.contactDelegate = self
    }
    
    override func didMove(to view: SKView) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTap(_:)))
        view.addGestureRecognizer(tap)
        let pan = UIPanGestureRecognizer(target: self, action: #selector(didPan(_:)))
        view.addGestureRecognizer(pan)
    }
    
    private func addGameOver() {
        let label = SKLabelNode(text: "Game Over 😈")
        label.position = center
        addChild(label)
    }
    
    private func spawnVegetable() {
        let enemy = self.enemy
        enemy.name = "enemy"
        addChild(enemy)
        enemy.position.x = randomXPosition()
        enemy.position.y = size.height
        
        // A physics body enables our node to be affected by gravity
        let physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: enemy.frame.size.width, height: enemy.frame.size.height ))
        physicsBody.collisionBitMask = 1
        enemy.physicsBody = physicsBody
        
        let actionGroup = SKAction.group([
            .rotate(byAngle: .pi, duration: 1)
            ])
        enemy.run(actionGroup) { [weak enemy] in
            enemy?.removeFromParent()
        }
    }
    
    func addKnife(origin: CGPoint) {
        let knife = SKLabelNode(text: "🔪")
        knife.name = "knife"
        knife.position = origin
        knife.setScale(1)
        
        let physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: knife.frame.size.width, height: knife.frame.size.height ))
        knife.physicsBody = physicsBody
        knife.physicsBody?.isDynamic = false
        knife.physicsBody?.contactTestBitMask = 1
        
        knifes.insert(knife)
        addChild(knife)
        let action = SKAction.rotate(byAngle: .pi*20, duration: 10)
        knife.run(action)
        knife.run(.moveTo(y: frame.height, duration: 2)) { [weak self] in
            knife.removeFromParent()
            self?.knifes.remove(knife)
        }
    }
}

extension CakeKillerScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.node == cake || contact.bodyB.node == cake {
            [contact.bodyA, contact.bodyB].filter { $0.node != cake }.forEach { $0.node?.removeFromParent() }
            let skull = SKLabelNode(text: "☠️")
            skull.setScale(0.1)
            skull.position = cake.position
            addChild(skull)
            cake.removeFromParent()
            skull.run(.scale(by: 20, duration: 1)) {
                skull.removeFromParent()
                self.removeAllActions()
                self.removeAllChildren()
                self.addGameOver()
            }
            return
        }
        
        
        if let knife = [contact.bodyA, contact.bodyB].filter({ $0.node!.name == "knife" }).first,
            let enemy = [contact.bodyA, contact.bodyB].filter({ $0.node!.name == "enemy" }).first {
            let ghost = SKLabelNode(text: "👻")
            ghost.setScale(0.1)
            ghost.position = enemy.node!.position
            addChild(ghost)
            knife.node!.removeFromParent()
            enemy.node!.removeFromParent()
            ghost.run(.scale(by: 10, duration: 1)) {
                ghost.removeFromParent()
            }
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        
    }
}

extension CakeKillerScene {
    @objc func didTap(_ recognizer: UITapGestureRecognizer) {
        let origin = CGPoint(x: cake.position.x,
                             y: cake.position.y + 50)
        addKnife(origin: origin)
    }
    
    @objc func didPan(_ recognizer: UIPanGestureRecognizer) {
        var location = recognizer.location(in: recognizer.view)
        location.y = cake.position.y
        cake.run(.move(to: location, duration: 0.1))
    }
}
