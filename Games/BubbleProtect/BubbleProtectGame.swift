import Foundation
import SpriteKit

/// Game implementation for demo purposes
final class BubbleProtectGame: Game {
    var name: String { return "Bubble Protect" }
    var authors: [String] { return ["Niels & Vasilica"] }
    
    func makeScene() -> SKScene {
        return BubbleProtectScene(size: UIScreen.main.bounds.size)
    }
}

