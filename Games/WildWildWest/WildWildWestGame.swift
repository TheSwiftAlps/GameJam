import Foundation
import SpriteKit

final class WildWildWestGame: Game {
    var name: String { return "Wild Wild West" }
    var authors: [String] { return ["Marijn Schilling & Germain Hugon"] }

    func makeScene() -> SKScene {
        return WildWildWestScene(size: UIScreen.main.bounds.size)
    }
}

