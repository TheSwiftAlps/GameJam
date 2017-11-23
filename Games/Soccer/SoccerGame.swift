//
//  SoccerGame.swift
//  Swift Alps Game Jam
//
//  Created by Sameh Mabrouk on 23/11/2017.
//

import Foundation
import SpriteKit

/// Game implementation for demo purposes
final class SoccerGame: Game {
    var name: String { return "Soccer Game" }
    var authors: [String] { return ["Sameh Mabrouk"] }
    
    func makeScene() -> SKScene {
        return SoccerScene(size: UIScreen.main.bounds.size)
    }
}

