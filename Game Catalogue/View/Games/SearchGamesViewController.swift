//
//  SearchGamesViewController.swift
//  Game Catalogue
//
//  Created by Budi Darmawan on 28/09/21.
//

import UIKit

protocol SearchProtocol {
  func onClickItem(id: Int)
}

class SearchGamesViewController: UIViewController {
  
  func delegateSearchProtocol(_ searchProtocol: SearchProtocol) {
    self.searchProtocol = searchProtocol
  }
  
  func searchGames(querySearch: String) {
    let query = querySearch.trimmingCharacters(in: .whitespaces)
    if self.querySearch != query {
      self.querySearch = query
      if self.querySearch.isEmpty {
        debouncer.cancel()
        setEmptyTableView()
      } else {
        debouncer.call()
      }
    }
  }
  
  @IBOutlet weak var gamesTableView: UITableView!
  
  var searchProtocol: SearchProtocol? = nil
  private lazy var gamesViewModel: GamesViewModel = {
    return GamesViewModel()
  }()
  private lazy var debouncer: Debouncer = {
    return Debouncer(delay: 0.5, callback: self.callGetGamesByQuery)
  }()
  
  private var listGamesByQuery: [Game] = [Game]()
  private var querySearch = ""
  private var stateTableView = StateView.loading
  
  override func viewWillAppear(_ animated: Bool) {
    setEmptyTableView()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    initTableView()
    observerViewModel()
  }
  
  private func callGetGamesByQuery() {
    gamesViewModel.getGamesBySearch(query: querySearch)
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
  
  
  private func observerViewModel() {
    gamesViewModel.listGamesBySearch.bind { games in
      switch games {
      case .loading:
        self.stateTableView = .loading
        self.listGamesByQuery.removeAll()
        self.updateTableView()
      case .error(let msg, _):
        print(msg ?? "ERROR")
      case .success(let data):
        self.stateTableView = .showing
        let results = data?.results ?? []
        self.listGamesByQuery.removeAll()
        self.listGamesByQuery.append(contentsOf: results)
        self.updateTableView()
      case .none:
        break
      }
    }
  }
  
  private func updateTableView() {
    DispatchQueue.main.async {
      if self.querySearch.isEmpty {
        self.listGamesByQuery.removeAll()
        self.gamesTableView.setBackgroundViewWithImage(image: UIImage(named: "icon_search"),
                                                       message: "Waiting to search ...")
      } else if self.listGamesByQuery.isEmpty {
        self.gamesTableView.setBackgroundViewWithImage(image: UIImage(named: "icon_error_search"),
                                                       message: "Game \"\(self.querySearch)\" not found!")
      } else {
        self.gamesTableView.restore(separator: .singleLine)
      }
      self.gamesTableView.reloadData()
    }
  }
  
  private func setEmptyTableView() {
    self.listGamesByQuery.removeAll()
    self.gamesTableView.setBackgroundViewWithImage(image: UIImage(named: "icon_search"),
                                                   message: "Waiting to search ...")
    DispatchQueue.main.async {
      self.gamesTableView.reloadData()
    }
  }
}

// MARK: TableView
extension SearchGamesViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if querySearch.isEmpty {
      return 0
    } else {
      return stateTableView == .loading ? 8 : listGamesByQuery.count
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(
            withIdentifier: GameTableViewCell.identifier, for: indexPath) as? GameTableViewCell else {
      return UITableViewCell()
    }
    
    if cell.state(stateTableView) {
      let game: Game
      game = self.listGamesByQuery[indexPath.row]
      cell.configureCell(game)
    }
    cell.selectionStyle = .none
    return cell
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    guard let header = gamesTableView.dequeueReusableHeaderFooterView(
            withIdentifier: HeaderGamesTableView.identifier) as? HeaderGamesTableView else {
      return nil
    }
    header.configureContents(title: "List Games \"\(querySearch)\"")
    return header
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return querySearch.isEmpty ? 0 : 50
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if stateTableView == .showing {
      searchProtocol?.onClickItem(id: listGamesByQuery[indexPath.row].id)
    }
  }
}
