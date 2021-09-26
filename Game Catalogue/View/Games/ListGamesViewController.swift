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
  private var stateTableView = StateView.loading
  private var firstLoad = true
  
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
  
  private func observerGameDefault() {
    gamesViewModel.getDataGames()
    gamesViewModel.listGames.bind { games in
      switch games {
      case .loading:
        self.stateTableView = StateView.loading
        self.updateTableView()
      case .error(let msg, _):
        print(msg ?? "ERROR")
      case .success(let data):
        self.firstLoad = false
        let results = data?.results ?? []
        self.listGames.append(contentsOf: results)
        self.stateTableView = StateView.showing
        self.updateTableView()
      case .none:
        break
      }
    }
  }
  
  private func observerGameTop() {
    gamesViewModel.getGamesTopRated()
    gamesViewModel.listGamesTopRated.bind { games in
      switch games {
      case .loading:
        self.stateTableView = StateView.loading
        self.updateTableView()
      case .error(let msg, _):
        print(msg ?? "ERROR")
      case .success(let data):
        self.firstLoad = false
        let results = data?.results ?? []
        self.listGames.append(contentsOf: results)
        self.stateTableView = StateView.showing
        self.updateTableView()
      case .none:
        break
      }
    }
  }
  
  private func initTableView() {
    gamesTableView.register(GameTableViewCell.nib(),
                            forCellReuseIdentifier: GameTableViewCell.identifier)
    gamesTableView.register(ShimmerGameTableViewCell.nib(),
                            forCellReuseIdentifier: ShimmerGameTableViewCell.identifier)
    gamesTableView.register(HeaderGamesTableView.nib(),
                            forHeaderFooterViewReuseIdentifier: HeaderGamesTableView.identifier)
    gamesTableView.delegate = self
    gamesTableView.dataSource = self
    gamesTableView.tableFooterView = UIView()
  }
  
  private func updateTableView() {
    DispatchQueue.main.async {
      self.gamesTableView.reloadData()
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    title = "Games"
    navigationItem.largeTitleDisplayMode = .never
  }
}

// MARK: TableView
extension ListGamesViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if firstLoad {
      switch stateTableView {
      case .loading:
        return 8
      case .showing:
        return listGames.count
      }
    } else {
      return listGames.count
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if firstLoad {
      switch stateTableView {
      case .loading:
        guard let cell = tableView.dequeueReusableCell(
                withIdentifier: ShimmerGameTableViewCell.identifier, for: indexPath) as? ShimmerGameTableViewCell else {
          return UITableViewCell()
        }
        return cell
      case .showing:
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
    } else {
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
