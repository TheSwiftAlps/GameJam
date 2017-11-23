//
//  VolcanoCannonGame.swift
//  Swift Alps Game Jam
//
//  Created by Dennis Charmington on 2017-11-23.
//

import Foundation
import SpriteKit

/// Game implementation for demo purposes
final class VolcanoCannonGame: Game {
    var name: String { return "VolcanoCannon" }
    var authors: [String] { return ["Alex Joly", "Sam Bichsel"] }
    
    func makeScene() -> SKScene {        
        return VolcanoCannonScene(size: UIScreen.main.bounds.size)
    }
}


