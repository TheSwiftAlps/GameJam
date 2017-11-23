/**
 *  Swift Alps Game Jam
 *  Copyright (c) John Sundell 2017
 *  MIT license. See LICENSE file for details.
 */

import UIKit
import SpriteKit

final class GameViewController: UIViewController {
    override var prefersStatusBarHidden: Bool { return true }
    var scene: SKScene?

    private lazy var gameView = SKView()

    override func viewDidLoad() {
        super.viewDidLoad()
        gameView.showsPhysics = true
        view.addSubview(gameView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gameView.frame = view.bounds

        if gameView.scene == nil {
            gameView.presentScene(scene)
        }
    }
}
