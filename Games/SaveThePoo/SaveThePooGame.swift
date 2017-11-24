//
//  SaveThePooGame.swift
//  Swift Alps Game Jam
//
//  Created by Askia Linder on 2017-11-23.
//

import Foundation
import SpriteKit

final class SaveThePooGame: Game {
    var name: String {
        return "SaveThePooGame"
    }
    /// The name of the people who made the game
    var authors: [String] {
        return["Askia", "Roman"]
    }
    
    /// Initialize the game. Will be done automatically by the app.
    init() {}
    
    /// Make the game's initial scene. Will be automatically presented by the app.
    func makeScene() -> SKScene {
        return PooScene(size: UIScreen.main.bounds.size)
    }
}
