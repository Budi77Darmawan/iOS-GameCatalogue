//
//  BookmarksViewController.swift
//  Game Catalogue
//
//  Created by Budi Darmawan on 26/09/21.
//

import UIKit

class BookmarksViewController: UIViewController {
  
  @IBOutlet weak var gamesTableView: UITableView!
  
  private var listGames: [DetailGame] = [DetailGame]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    initTableView()
  }
  
  private func initTableView() {
    gamesTableView.register(GameTableViewCell.nib(),
                            forCellReuseIdentifier: GameTableViewCell.identifier)
    gamesTableView.register(HeaderGamesTableView.nib(),
                            forHeaderFooterViewReuseIdentifier: HeaderGamesTableView.identifier)
    gamesTableView.delegate = self
    gamesTableView.dataSource = self
    gamesTableView.tableFooterView = UIView()
  }
  
  private func updateTableView() {
    DispatchQueue.main.async {
      self.listGames = DatabaseCall.getGamesOnDatabase()
      if self.listGames.isEmpty {
        self.gamesTableView.setBackgroundViewWithImage(image: UIImage(named: "icon_empty_items"),
                                                       message: "The Bookmarks is empty")
      } else {
        self.gamesTableView.restore(separator: .singleLine)
      }
      self.gamesTableView.reloadData()
    }
  }
  
  private func navigateToDetailGame(id: Int) {
    let detailVC = DetailGameViewController(nibName: "DetailGameViewController", bundle: nil)
    detailVC.gameID = id
    self.navigationController?.pushViewController(detailVC, animated: true)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    self.updateTableView()
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationItem.largeTitleDisplayMode = .always
    tabBarController?.tabBar.isHidden = false
  }
}

// MARK: TableView
extension BookmarksViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return listGames.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(
            withIdentifier: GameTableViewCell.identifier, for: indexPath) as? GameTableViewCell else {
      return UITableViewCell()
    }
    
    let detailGame: DetailGame
    detailGame = listGames[indexPath.row]
    cell.configureCell(detailGame)
    cell.selectionStyle = .none
    return cell
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    guard let header = gamesTableView.dequeueReusableHeaderFooterView(
            withIdentifier: HeaderGamesTableView.identifier) as? HeaderGamesTableView else {
      return nil
    }
    header.configureContents(title: "All Lists")
    return header
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    if listGames.isEmpty {
      return 0
    } else {
      return 50
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    navigateToDetailGame(id: listGames[indexPath.row].id)
  }
}
