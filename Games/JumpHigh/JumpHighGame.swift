//
//  JumpHighGame.swift
//  Swift Alps Game Jam
//
//  Created by Florin Voicu on 23/11/2017.
//

import Foundation
import SpriteKit

/// Game implementation for demo purposes
final class JumpHighGame: Game {
    var name: String { return "JumpHighGame" }
    var authors: [String] { return ["Florin Voicu", "George Muntean"] }
    
    func makeScene() -> SKScene {
        return JumpHighScene(size: UIScreen.main.bounds.size)
    }
}
