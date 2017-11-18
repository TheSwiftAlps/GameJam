/**
 *  Swift Alps Game Jam
 *  Copyright (c) John Sundell 2017
 *  MIT license. See LICENSE file for details.
 */

import UIKit

final class GameListViewController: UITableViewController {
    override var prefersStatusBarHidden: Bool { return true }

    private let games = GameFactory().makeGames()
    private let cellReuseIdentifier = "gameCell"

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "🕹 Swift Alps Game Jam"
        tableView.register(Cell.self, forCellReuseIdentifier: cellReuseIdentifier)
    }

    // MARK: - UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let game = games[indexPath.row]
        let authorsText = game.authors.joined(separator: ", ")

        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
        cell.textLabel?.text = game.name
        cell.detailTextLabel?.text = "By \(authorsText)"
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    // MARK: - UITableViewDelegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let game = games[indexPath.row]

        let viewController = GameViewController()
        viewController.title = game.name
        viewController.scene = game.makeScene()
        navigationController?.pushViewController(viewController, animated: true)
    }
}

private extension GameListViewController {
    final class Cell: UITableViewCell {
        override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
            super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
            detailTextLabel?.textColor = .lightGray
        }

        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}
