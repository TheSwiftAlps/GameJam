import SpriteKit
import PlaygroundSupport

/*struct Categories {
    static let ground: UInt32 = 1
    static let coins: UInt32 = 1 << 1
}

class Scene: SKScene {
    let player = SKSpriteNode(imageNamed: "Character")
    lazy var ground = makeGround()

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
        player.physicsBody?.contactTestBitMask = Categories.coins
        addChild(player)

        Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { [weak self] _ in
            guard let scene = self else {
                return
            }

            let money = SKLabelNode(text: "💰")
            money.setScale(2)
            money.verticalAlignmentMode = .center
            money.position.x = -money.frame.width
            money.position.y = 300
            money.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 50, height: 50))
            money.physicsBody?.isDynamic = false
            money.physicsBody?.categoryBitMask = Categories.coins
            scene.addChild(money)

            money.run(.moveTo(x: scene.size.width + money.frame.width, duration: 3)) {
                money.removeFromParent()
            }
        }

        physicsWorld.contactDelegate = self
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)

        let playerBody = player.physicsBody!
        let groundBody = ground.physicsBody!

        guard playerBody.allContactedBodies().contains(groundBody) else {
            return
        }

        playerBody.applyImpulse(CGVector(dx: 0, dy: 200))
    }

    private func makeGround() -> SKShapeNode {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: 100)
        return SKShapeNode(rect: rect)
    }
}

extension Scene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.node == player {
            contact.bodyB.node?.removeFromParent()
        } else {
            contact.bodyA.node?.removeFromParent()
        }
    }
}
*/

final class RocketScene: SKScene {

    override func sceneDidLoad() {
        super.sceneDidLoad()

        let car = SKSpriteNode(imageNamed: "Car")

        addChild(car)

    }
}

let viewFrame = CGRect(x: 0, y: 0, width: 365, height: 667)
let view = SKView(frame: viewFrame)
view.presentScene(RocketScene(size: viewFrame.size))
PlaygroundPage.current.liveView = view
