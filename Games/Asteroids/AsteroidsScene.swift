import Foundation
import SpriteKit


extension AsteroidsScene: SKPhysicsContactDelegate {

    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.node == rocket || contact.bodyB.node == rocket {
            
            [contact.bodyA, contact.bodyB].filter { $0.node != rocket }.forEach { $0.node?.removeFromParent() }
            
            let textures: [SKTexture] = [
                SKTexture(imageNamed: "Explosion-0"),
                SKTexture(imageNamed: "Explosion-1"),
                SKTexture(imageNamed: "Explosion-2"),
                SKTexture(imageNamed: "Explosion-3"),
                SKTexture(imageNamed: "Explosion-4"),
                SKTexture(imageNamed: "Explosion-5"),
                SKTexture(imageNamed: "Explosion-6")
            ]
            rocket.run(.animate(with: textures, timePerFrame: 0.05)) {
                self.rocket.removeFromParent()
                self.removeAllActions()
                self.removeAllChildren()
                self.addGameOver()
            }
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        
    }
    
}

/// Scene for the demo game.
class AsteroidsScene: SKScene {

    private var score = 0
    private lazy var scoreLabel = SKLabelNode()
    private lazy var rocket = SKSpriteNode(imageNamed: "Rocket")
    
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
                self?.spawnAsteroid()
            })
            ])))
        spawnRocket()
        physicsWorld.contactDelegate = self
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
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        super.touchesBegan(touches, with: event)
        
        // Just like we can get a touch location from a view, we can get it from a node as well
        guard let touchLocation = touches.first?.location(in: self) else {
            return
        }
        
        let move = SKAction.move(to: CGPoint(x: touchLocation.x, y: 100), duration: 0.3)
        rocket.run(move)
    }
    
    // MARK: - Private
    
    private func spawnAsteroid() {
        let asteroid = SKSpriteNode(imageNamed: "Asteroid")
        asteroid.setScale(0.5)
        
        // We insert the emoji at the bottom of the hierarchy, to create a 3D effect
        // that the current emojis are in front of it depth-wise
        addChild(asteroid)
        
        // Put the emoji at a random X position (as long as its completely within the scene)
        // Then put it right below the scene (in SpriteKit, y=0 means the bottom)
        asteroid.position.x = randomXPosition()
        
        
        asteroid.position.y = size.height
        
        // A physics body enables our node to be affected by gravity
        let physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: asteroid.size.width, height: asteroid.size.height ))
        physicsBody.collisionBitMask = 1
        asteroid.physicsBody = physicsBody
        
        // An impulse applies a direct force to the emoji, causing it to shoot upwards
        
        let moveDuration: TimeInterval = 2
        
        // Rotate and scale the emoji to cause a crazy effect
        let actionGroup = SKAction.group([
            .rotate(byAngle: .pi * 2, duration: moveDuration)
            ])
        
        // Once the action is done we're finished with the emoji and it can be removed
        asteroid.run(actionGroup) { [weak asteroid] in
            asteroid?.removeFromParent()
        }
    }
    
    private func spawnRocket() {
        rocket.setScale(1.0)
        addChild(rocket)

        rocket.position.x = size.height / 2
        rocket.position.y = 100
        
        let physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: rocket.size.width, height: rocket.size.height))
        physicsBody.collisionBitMask = 0
        rocket.physicsBody = physicsBody
        rocket.physicsBody?.isDynamic = false
        rocket.physicsBody?.contactTestBitMask = 1
        
        
//        rocket.run(actionGroup) { [weak rocket] in
//            rocket?.removeFromParent()
//        }
    }
    
    private func addGameOver() {
        let label = SKLabelNode(text: "Game Over!!!")
        label.position = center
        addChild(label)
    }
    

}


private extension SKNode {
    /// Property used to keep track of whether a node is an emoji or not
    var isEmoji: Bool {
        get { return self[#function] ?? false }
        set { self[#function] = newValue }
    }
}

