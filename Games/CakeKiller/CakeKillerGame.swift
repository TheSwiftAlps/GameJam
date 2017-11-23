import Foundation
import SpriteKit

/// Game implementation for demo purposes
final class CakeKillerGame: Game {
    var name: String { return "CakeKiller" }
    var authors: [String] { return ["Jonas Schmid", "Luis Ascorbe"] }
    
    func makeScene() -> SKScene {
        return CakeKillerScene(size: UIScreen.main.bounds.size)
    }
}

