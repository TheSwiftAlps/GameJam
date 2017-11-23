//
//  DrinkingGame.swift
//  Swift Alps Game Jam
//
//  Created by Sidney de Koning on 23/11/2017.
//

import Foundation
import SpriteKit

/// Game implementation for demo purposes
final class DrinkingGame: Game {
    var name: String { return "Drinking Game" }
    var authors: [String] { return ["Maria", "Sidney"] }
    
    func makeScene() -> SKScene {
        return DrinkingGameScene(size: UIScreen.main.bounds.size)
    }
}
