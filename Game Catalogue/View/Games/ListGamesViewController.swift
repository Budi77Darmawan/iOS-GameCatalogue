//
//  ListGamesViewController.swift
//  Game Catalogue
//
//  Created by Budi Darmawan on 15/09/21.
//

import UIKit

class ListGamesViewController: UIViewController {
  
  @IBOutlet weak var gamesTableView: UITableView!
  
  var titleTable: String = ""
  var gameType: GameType? = nil
  private var gamesViewModel: GamesViewModel!
  private var listGames: [Game] = [Game]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    initTableView()
    
    gamesViewModel = GamesViewModel()
    switch gameType {
    case .normal:
      observerGameDefault()
    case .topRated:
      observerGameTop()
    default:
      break
    }
  }
  
  func observerGameDefault() {
    gamesViewModel.getDataGames()
    gamesViewModel.bindListGamesToController = { games in
      switch games {
      case .loading:
        print("LOADING")
      case .error(let msg, _):
        print(msg ?? "ERROR")
      case .success(let data):
        DispatchQueue.main.async {
          print("SUCCESS")
          let results = data?.results ?? []
          self.listGames.append(contentsOf: results)
          self.gamesTableView.reloadData()
        }
      }
    }
  }
  
  func observerGameTop() {
    gamesViewModel.getGamesTopRated()
    gamesViewModel.bindListGamesTopRatedToController = { games in
      switch games {
      case .loading:
        print("LOADING")
      case .error(let msg, _):
        print(msg ?? "ERROR")
      case .success(let data):
        DispatchQueue.main.async {
          print("SUCCESS")
          let results = data?.results ?? []
          self.listGames.append(contentsOf: results)
          self.gamesTableView.reloadData()
        }
      }
    }
  }
  
  func initTableView() {
    gamesTableView.register(GameTableViewCell.nib(),
                            forCellReuseIdentifier: GameTableViewCell.identifier)
    gamesTableView.register(HeaderGamesTableView.nib(),
                            forHeaderFooterViewReuseIdentifier: HeaderGamesTableView.identifier)
    gamesTableView.delegate = self
    gamesTableView.dataSource = self
    gamesTableView.tableFooterView = UIView()
  }
}

// MARK: TableView
extension ListGamesViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return listGames.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(
            withIdentifier: GameTableViewCell.identifier, for: indexPath) as? GameTableViewCell else {
      return UITableViewCell()
    }
    let game = self.listGames[indexPath.row]
    cell.configureCell(game)
    guard let type = gameType else {
      return cell
    }
    gamesViewModel.loadNextPageGames(lastGame: game, type: type)
    return cell
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    guard let header = gamesTableView.dequeueReusableHeaderFooterView(
            withIdentifier: HeaderGamesTableView.identifier) as? HeaderGamesTableView else {
      return nil
    }
    header.configureContents(title: titleTable)
    return header
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 50
  }
  
}
