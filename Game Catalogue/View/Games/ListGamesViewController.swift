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
  private var withShimmer = true
  
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
        self.stateTableView = .loading
        self.updateTableView()
      case .error(let msg, _):
        print(msg ?? "ERROR")
      case .success(let data):
        self.stateTableView = .showing
        let results = data?.results ?? []
        self.listGames.append(contentsOf: results)
        self.updateTableView()
      case .none:
        break
      }
    }
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
      self.gamesTableView.reloadData()
    }
  }
  
  private func navigateToDetailGame(id: Int) {
    let detailVC = DetailGameViewController(nibName: "DetailGameViewController", bundle: nil)
    detailVC.gameID = id
    self.navigationController?.pushViewController(detailVC, animated: true)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    title = "Games"
    navigationItem.largeTitleDisplayMode = .never
    tabBarController?.tabBar.isHidden = true
  }
}

// MARK: TableView
extension ListGamesViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if withShimmer {
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
    guard let cell = tableView.dequeueReusableCell(
            withIdentifier: GameTableViewCell.identifier, for: indexPath) as? GameTableViewCell else {
      return UITableViewCell()
    }
    
    if cell.state(stateTableView, withShimmer) {
      let game = listGames[indexPath.row]
      cell.configureCell(game)
      cell.selectionStyle = .none
      guard let type = gameType else {
        return cell
      }
      withShimmer = !gamesViewModel.loadNextPageGames(lastGame: game, type: type)
    }
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
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if !withShimmer || stateTableView == .showing {
      self.navigateToDetailGame(id: listGames[indexPath.row].id)
    }
  }
}
