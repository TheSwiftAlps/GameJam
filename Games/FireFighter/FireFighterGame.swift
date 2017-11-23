import Foundation
import SpriteKit

/// Game implementation for demo purposes
final class FireFighterGame: Game {
    var name: String { return "Fire Fighter Game" }
    var authors: [String] { return ["Ana", "Karim"] }
    
    func makeScene() -> SKScene {
        return FireFighterScene(size: UIScreen.main.bounds.size)
    }
}

