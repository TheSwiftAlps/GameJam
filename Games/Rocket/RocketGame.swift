//
//  RocketGame.swift
//  Swift Alps Game Jam
//
//  Created by Petteri Hyttinen on 2017-11-23.
//

import Foundation
import SpriteKit

/// Game implementation for demo purposes
final class RocketGame: Game {
    var name: String { return "Rocket Game" }
    var authors: [String] { return ["Petteri & Janne"] }

    func makeScene() -> SKScene {
        return RocketScene(size: UIScreen.main.bounds.size)
    }
}

