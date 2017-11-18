/**
 *  Swift Alps Game Jam
 *  Copyright (c) John Sundell 2017
 *  MIT license. See LICENSE file for details.
 */

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let navigationController = UINavigationController(
            rootViewController: GameListViewController()
        )

        navigationController.navigationBar.barStyle = .blackTranslucent

        let window = UIWindow(frame: UIScreen.main.bounds)
        window.tintColor = .white
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.window = window

        return true
    }
}

