//
//  DeathStarGame.swift
//  Swift Alps Game Jam
//
//  Created by Eran Jalink on 23/11/2017.
//

import Foundation
import SpriteKit

/// Game implementation for demo purposes
final class DeathStarGame: Game {
    var name: String { return "Death Star" }
    var authors: [String] { return ["Eran & Viktor"] }
    
    func makeScene() -> SKScene {
        return DeathStarScene(size: UIScreen.main.bounds.size)
    }
}


