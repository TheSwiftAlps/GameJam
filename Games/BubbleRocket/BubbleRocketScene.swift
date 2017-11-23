import SpriteKit
import CoreMotion

class BubbleRocketScene: SKScene {
    struct Categories {
        static let rocket: UInt32 = 1
        static let ground: UInt32 = 1 << 1
        static let bubble: UInt32 = 1 << 2
    }

    let player = SKSpriteNode(imageNamed: "Rocket")
    var bubbles = Set<SKSpriteNode>()
    let motionManager = CMMotionManager()
    var running = true

    func addGround() {
        let ground = SKSpriteNode(imageNamed: "Platform-Single")
        ground.setScale(2)
        let random = arc4random_uniform(UInt32(self.frame.width))
        ground.position.x = CGFloat(random)
        ground.position.y = self.frame.height
        ground.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 50, height: 50))
        ground.physicsBody?.isDynamic = true
        ground.physicsBody?.categoryBitMask = Categories.ground
        self.addChild(ground)
    }

    override func sceneDidLoad() {
        super.sceneDidLoad()
        motionManager.deviceMotionUpdateInterval = 5.0 / 60.0;
        player.position.x = frame.midX
        player.position.y = 100
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody!.isDynamic = false
        player.physicsBody?.collisionBitMask = Categories.rocket
        player.physicsBody?.contactTestBitMask = Categories.ground
        addChild(player)
        motionManager.startDeviceMotionUpdates(to: OperationQueue.main) { [weak self] (motion, error) in
            guard let motion = motion, let scene = self else { return }
            let r = sqrt(motion.gravity.x * motion.gravity.x + motion.gravity.y * motion.gravity.y + motion.gravity.z * motion.gravity.z)
            let forwardsBackwards = acos(motion.gravity.x / r) * 180.0 / M_PI - 90.0
            var newX = scene.player.position.x - CGFloat(forwardsBackwards)
            if newX >= (scene.size.width - scene.player.size.width) {
                newX = scene.size.width - scene.player.size.width
            }
            else if newX < 0 { newX = 0 }
            scene.player.run(.moveTo(x: newX, duration: 0.05))
        }

        Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { [weak self] _ in
            guard let scene = self, scene.running == true else {
                return
            }

            scene.addGround()
            scene.addGround()
            scene.addGround()
        }

        physicsWorld.contactDelegate = self
    }

    func addBubble(origin: CGPoint) {
        let bubble = SKSpriteNode(imageNamed: "Bubble-0")
        bubble.position = origin
        bubble.setScale(0.3)
        bubble.physicsBody = SKPhysicsBody(rectangleOf: bubble.size)
        bubble.physicsBody!.isDynamic = false
        bubble.physicsBody?.contactTestBitMask = Categories.ground
        bubble.physicsBody?.collisionBitMask = Categories.bubble
        bubbles.insert(bubble)
        addChild(bubble)
        let textures: [SKTexture] = [
            SKTexture(imageNamed: "Bubble-0"),
            SKTexture(imageNamed: "Bubble-1"),
            SKTexture(imageNamed: "Bubble-2"),
            SKTexture(imageNamed: "Bubble-3"),
            SKTexture(imageNamed: "Bubble-4")
        ]
        bubble.run(.animate(with: textures, timePerFrame: 1))
        bubble.run(.moveTo(y: frame.height * 0.8, duration: 4)) { [weak self] in
            bubble.removeFromParent()
            self?.bubbles.remove(bubble)
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard running == true else { return }
        super.touchesBegan(touches, with: event)
        let origin = CGPoint(x: player.position.x,
                             y: player.position.y + player.size.height)
        addBubble(origin: origin)
    }

    private func makeGround() -> SKShapeNode {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: 100)
        return SKShapeNode(rect: rect)
    }

    private func explodeyTime(_ collisionPoint: CGPoint) {
        let fire = SKSpriteNode(imageNamed: "Explosion-0")
        fire.setScale(5)
        fire.position.x = collisionPoint.x
        fire.position.y = collisionPoint.y
        addChild(fire)

        let textures: [SKTexture] = [
            SKTexture(imageNamed: "Explosion-0"),
            SKTexture(imageNamed: "Explosion-1"),
            SKTexture(imageNamed: "Explosion-2"),
            SKTexture(imageNamed: "Explosion-3"),
            SKTexture(imageNamed: "Explosion-4"),
            SKTexture(imageNamed: "Explosion-5"),
            SKTexture(imageNamed: "Explosion-6")
        ]
        fire.run(.scale(by: 4.7, duration: 0.6))
        fire.run(.animate(with: textures, timePerFrame: 0.1)) {
            self.removeAllActions()
            self.removeAllChildren()
        }
    }
}

extension BubbleRocketScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node as? SKSpriteNode else { return }
        guard let nodeB = contact.bodyB.node as? SKSpriteNode else { return }
        if nodeA == player {
            explodeyTime(contact.contactPoint)
            nodeB.removeFromParent()
            running = false
        }
    }
}
