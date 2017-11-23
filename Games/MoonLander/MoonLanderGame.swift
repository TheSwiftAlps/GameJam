//  Created by Nikola Lajic on 11/23/17.
//  Copyright © 2017 ___ORGANIZATIONNAME___. All rights reserved.

import Foundation
import SpriteKit

final class MoonLanderGame: Game {
    var name: String { return "Moon Lander" }
    var authors: [String] { return ["Nikola Lajic", "Milan Stevanovic"] }
    
    func makeScene() -> SKScene {
        return MoonLanderScene(size: UIScreen.main.bounds.size)
    }
}
