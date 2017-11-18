import Foundation
import SpriteKit

/// Game implementation for demo purposes
final class DemoGame: Game {
    var name: String { return "Demo Game" }
    var authors: [String] { return ["John Sundell"] }

    func makeScene() -> SKScene {
        return DemoScene(size: UIScreen.main.bounds.size)
    }
}
