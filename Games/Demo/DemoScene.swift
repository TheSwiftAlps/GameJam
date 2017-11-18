import Foundation
import SpriteKit

/// Scene for the demo game.
final class DemoScene: SKScene {
    private let allEmoji = ["😲", "😎", "😂", "🤠", "😱"]
    private var score = 0
    private lazy var scoreLabel = SKLabelNode()

    // MARK: - SKScene

    // This is called when the scene is fist loaded into memory
    override func sceneDidLoad() {
        super.sceneDidLoad()

        // Use a lower gravity than in "real life" to make it easier to tap the emoji
        physicsWorld.gravity.dy /= 2

        // Spawn a new emoji every 0.5 seconds
        run(.repeatForever(.sequence([
            .wait(forDuration: 0.5),
            .run({ [weak self] in
                self?.spawnEmoji()
            })
        ])))
    }

    // This is called when the scene has moved to its view
    override func didMove(to view: SKView) {
        super.didMove(to: view)

        // We setup the score label here, since now the view's safe area insets are known
        scoreLabel.position.x = 10 + view.safeAreaInsets.left
        scoreLabel.position.y = 10 + view.safeAreaInsets.bottom
        scoreLabel.fontSize = 16
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)
    }

    // This is called when the user began touching the screen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)

        // Just like we can get a touch location from a view, we can get it from a node as well
        guard let touchLocation = touches.first?.location(in: self) else {
            return
        }

        guard let node = nodes(at: touchLocation).first as? SKLabelNode else {
            return
        }

        // Make sure that we're not causing the score label to explode
        guard node.isEmoji else {
            return
        }

        // By removing the node's physics body and all actions, we cause it to stop
        node.physicsBody = nil
        node.removeAllActions()
        node.text = "💥"

        node.run(.fadeOut(withDuration: 0.5)) { [weak node] in
            node?.removeFromParent()
        }

        score += 100
        scoreLabel.text = "SCORE: \(score)"
    }

    // MARK: - Private

    private func spawnEmoji() {
        let emoji = SKLabelNode(text: allEmoji.random())
        emoji.isEmoji = true
        emoji.fontSize = 80
        emoji.setScale(0.2)

        // We insert the emoji at the bottom of the hierarchy, to create a 3D effect
        // that the current emojis are in front of it depth-wise
        insertChild(emoji, at: 0)

        // Put the emoji at a random X position (as long as its completely within the scene)
        // Then put it right below the scene (in SpriteKit, y=0 means the bottom)
        emoji.position.x = randomXPosition()
        emoji.position.x = min(emoji.position.x, size.width - emoji.fontSize)
        emoji.position.x = max(emoji.position.x, emoji.fontSize)
        emoji.position.y = -emoji.fontSize

        // A physics body enables our node to be affected by gravity
        let physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 80, height: 80))
        physicsBody.collisionBitMask = 0
        emoji.physicsBody = physicsBody

        // An impulse applies a direct force to the emoji, causing it to shoot upwards
        emoji.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 280))

        let moveDuration: TimeInterval = 3

        // Rotate and scale the emoji to cause a crazy effect
        let actionGroup = SKAction.group([
            .scale(to: 1, duration: moveDuration),
            .rotate(byAngle: .pi * 2, duration: moveDuration)
        ])

        // Once the action is done we're finished with the emoji and it can be removed
        emoji.run(actionGroup) { [weak emoji] in
            emoji?.removeFromParent()
        }
    }
}

private extension SKNode {
    /// Property used to keep track of whether a node is an emoji or not
    var isEmoji: Bool {
        get { return self[#function] ?? false }
        set { self[#function] = newValue }
    }
}
