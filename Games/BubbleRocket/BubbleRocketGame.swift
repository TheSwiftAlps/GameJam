//
//  BubbleRocketGame.swift
//  Swift Alps Game Jam
//
//  Created by Danielle Tomlinson on 23/11/2017.
//

import Foundation
import SpriteKit

final class BubbleRocketGame: Game {
    var name: String { return "Bubble Rocket Game" }
    var authors: [String] { return ["Dani & Tommy"] }

    func makeScene() -> SKScene {
        return BubbleRocketScene(size: UIScreen.main.bounds.size)
    }
}
