//
//  GravityColliderGame.swift
//  Swift Alps Game Jam
//
//  Created by Dennis Charmington on 2017-11-23.
//

import Foundation
import SpriteKit

/// Game implementation for demo purposes
final class GravityColliderGame: Game {
    var name: String { return "GravityCollider" }
    var authors: [String] { return ["Dennis Charmington"] }
    
    func makeScene() -> SKScene {        
        return GravityColliderScene(size: UIScreen.main.bounds.size)
    }
}


