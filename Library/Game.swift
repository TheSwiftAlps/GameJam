import Foundation
import SpriteKit

/// Protocol used to define a Game
protocol Game {
    /// The name of the game
    var name: String { get }
    /// The name of the people who made the game
    var authors: [String] { get }

    /// Initialize the game. Will be done automatically by the app.
    init()

    /// Make the game's initial scene. Will be automatically presented by the app.
    func makeScene() -> SKScene
}
