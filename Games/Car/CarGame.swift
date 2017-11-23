//
//  CarGame.swift
//  Swift Alps Game Jam
//
//  Created by Noé on 23.11.17.
//

import Foundation
import SpriteKit

final class CarGame: Game {
    var name: String { return "Car" }
    var authors: [String] { return ["Noé Froidevaux"] }

    func makeScene() -> SKScene {
        return CarScene(size: UIScreen.main.bounds.size)
    }
}
