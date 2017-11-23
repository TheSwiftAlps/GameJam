//
//  SmileyBilliardGame.swift
//  Swift Alps Game Jam
//
//  Created by David Hart on 23.11.17.
//

import SpriteKit

final class SmileyBilliardGame: Game {
    var name: String { return "Smiley-Billiard Game" }
    var authors: [String] { return ["Monika Zielonka", "David Hart"] }

    func makeScene() -> SKScene {
        var size = UIScreen.main.bounds.size
        let navigationController = UIApplication.shared.keyWindow!.rootViewController as! UINavigationController
        size.height -= navigationController.navigationBar.frame.size.height
        let scene = SmileyBilliardScene(size: size)
        scene.scaleMode = .aspectFit
        return scene
    }
}
