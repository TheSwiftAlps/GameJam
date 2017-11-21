import SpriteKit
import PlaygroundSupport

class Scene: SKScene {
    override func sceneDidLoad() {
        super.sceneDidLoad()

        // Scene setup
    }
}

let viewFrame = CGRect(x: 0, y: 0, width: 365, height: 667)
let view = SKView(frame: viewFrame)
view.presentScene(Scene(size: viewFrame.size))
PlaygroundPage.current.liveView = view
