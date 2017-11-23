import Foundation
import SpriteKit

private struct Categories {
    static let bubble: UInt32 = 1
    static let emoji: UInt32 = 1 << 1
    static let character: UInt32 = 1 << 2
}

extension Bool {
    static var random: Bool {
        return arc4random_uniform(2) == 0
    }
}


extension BubbleProtectScene: SKPhysicsContactDelegate {

    func didBegin(_ contact: SKPhysicsContact) {
        switch (contact.bodyA.node!, contact.bodyB.node!) {
        case (player, _):
            contact.bodyB.node?.removeFromParent()
        case (bubble, _):
            let label = contact.bodyB.node as! SKLabelNode
            contact.bodyB.node?.removeFromParent()
            if label.text == "😁" {
                score += 1
            } else {
                score -= 1
            }
        default:()
        }
    }
}

/// Scene for the demo game.
class BubbleProtectScene: SKScene {

    let player = SKSpriteNode(imageNamed: "Character-Front-0")


    let textures: [SKTexture] = [
        SKTexture(imageNamed: "Bubble-1"),
        SKTexture(imageNamed: "Bubble-2"),
        SKTexture(imageNamed: "Bubble-3"),
        SKTexture(imageNamed: "Bubble-4")
    ]
    let bubble = SKSpriteNode()
    var score = 0 {
        didSet {
            scoreLabel.text = "\(score)"
        }
    }

    let pathSize: CGFloat = 200

    let scoreLabel = SKLabelNode(text: "0")

    override func sceneDidLoad() {
        super.sceneDidLoad()

        physicsWorld.gravity.dy = 0

        scoreLabel.position.x = scoreLabel.frame.size.width/2 + 10
        scoreLabel.position.y = frame.height - scoreLabel.frame.size.height - 60
        scoreLabel.fontColor = .white
        addChild(scoreLabel)

        bubble.position.x = frame.midX
        bubble.position.y = frame.midY
        bubble.size = CGSize(width: 100, height: 100)
        bubble.setScale(0.5)
        bubble.physicsBody = SKPhysicsBody(rectangleOf: bubble.frame.size)
        bubble.physicsBody?.isDynamic = true
        bubble.physicsBody?.categoryBitMask = Categories.bubble
        bubble.physicsBody?.collisionBitMask = 0
        addChild(bubble)

        player.position.x = frame.midX
        player.position.y = 200
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody?.isDynamic = true
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.categoryBitMask = Categories.character
        player.physicsBody?.collisionBitMask = 0

        addChild(player)

        let action: SKAction = .animate(with: textures, timePerFrame: 0.05, resize: true, restore: false)
        bubble.run(.repeatForever(.sequence([action,action.reversed()])))

        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let scene = self else {
                return
            }
            let emoji: SKLabelNode
            if Bool.random {
                emoji = SKLabelNode(text: "😁")
            } else {
                emoji = SKLabelNode(text: "😭")
            }

            var yPosition = CGFloat(arc4random_uniform(UInt32(scene.frame.height)))
            let xPostion = CGFloat(arc4random_uniform(UInt32(scene.frame.width)))

            if yPosition > scene.bubble.frame.midY {
                yPosition += 200
            } else {
                yPosition -= 200
            }


            emoji.verticalAlignmentMode = .center
            emoji.position.x = xPostion
            emoji.position.y = yPosition
            emoji.physicsBody = SKPhysicsBody(rectangleOf: emoji.frame.size)
            emoji.physicsBody?.isDynamic = true
            emoji.physicsBody?.affectedByGravity = false
            emoji.physicsBody?.collisionBitMask = 0
            emoji.physicsBody?.categoryBitMask = Categories.emoji
            emoji.physicsBody?.contactTestBitMask = Categories.bubble | Categories.character
            scene.addChild(emoji)



            emoji.run(.move(to: CGPoint(x: scene.bubble.frame.midX, y: scene.bubble.frame.midY), duration: 3)) {
                emoji.removeFromParent()
            }
        }

        physicsWorld.contactDelegate = self
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        player.run(.move(to: location, duration: 0.2))


        //        let path = CGPath(ellipseIn: CGRect(x: bubble.frame.midX - pathSize/2, y: bubble.frame.midY - pathSize/2, width: pathSize, height: pathSize), transform: nil)
        //
        //        player.run(.repeatForever(.follow(path, asOffset: false, orientToPath: false, speed: 100)))
    }
    

}
