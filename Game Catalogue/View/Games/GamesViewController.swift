//
//  ProfileViewController.swift
//  Game Catalogue
//
//  Created by Budi Darmawan on 10/07/21.
//

import UIKit

class GamesViewController: UIViewController {
  
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var headerTop: UIView!
  @IBOutlet weak var gamesTopCollectionView: UICollectionView!
  @IBOutlet weak var gamesTableView: UITableView!
  @IBOutlet weak var heightTable: NSLayoutConstraint!
  @IBOutlet weak var widthStack: NSLayoutConstraint!
  @IBOutlet weak var iconCapsule: UIImageView!
  @IBOutlet weak var tvGamesType: UILabel!
  
  private let searchController = UISearchController(searchResultsController: nil)
  private lazy var gamesViewModel: GamesViewModel! = {
    return GamesViewModel()
  }()
  private lazy var debouncer: Debouncer! = {
    return Debouncer(delay: 0.5, callback: self.callGetGamesByQuery)
  }()
  
  private var listGames: [Game] = [Game]()
  private var listGamesByQuery: [Game] = [Game]()
  private var listGamesTop: [Game] = [Game]()
  private let screenSize: CGRect = UIScreen.main.bounds
  private var querySearch = ""
  private var onSearch = false
  private var stateTableView = StateView.loading
  private var stateCollectionView = StateView.loading
  
  override func viewDidLoad() {
    super.viewDidLoad()
    searchController.delegate = self
    searchController.searchResultsUpdater = self
    searchController.obscuresBackgroundDuringPresentation = false
    navigationItem.searchController = searchController
    
    initView()
    initTableView()
    initCollectionView()
    observerViewModel()
  }
  
  private func observerViewModel() {
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
    
    gamesViewModel.listGamesTopRated.bind { games in
      switch games {
      case .loading:
        self.stateCollectionView = StateView.loading
        self.updateCollectionView()
      case .error(let msg, _):
        print(msg ?? "ERROR")
      case .success(let data):
        let results = data?.results ?? []
        self.listGamesTop.append(contentsOf: Array(results.prefix(5)))
        self.stateCollectionView = StateView.showing
        self.updateCollectionView()
      case .none:
        break
      }
    }
    
    gamesViewModel.listGamesBySearch.bind { games in
      switch games {
      case .loading:
        self.stateTableView = StateView.loading
        self.updateTableView()
      case .error(let msg, _):
        print(msg ?? "ERROR")
      case .success(let data):
        let results = data?.results ?? []
        self.listGamesByQuery.removeAll()
        self.listGamesByQuery.append(contentsOf: results)
        self.stateTableView = StateView.showing
        self.updateTableView()
      case .none:
        break
      }
    }
    
    gamesViewModel.getDataGames()
    gamesViewModel.getGamesTopRated()
  }
  
  private func callGetGamesByQuery() {
    gamesViewModel.getGamesBySearch(query: querySearch)
  }
  
  private func initView() {
    widthStack.constant = screenSize.width
    tvGamesType.text = "Top Rated"
    iconCapsule.backgroundColor = .systemBlue
    iconCapsule.rounded(4)
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
  
  private func initCollectionView() {
    gamesTopCollectionView.register(GameTopCollectionViewCell.nib(),
                                    forCellWithReuseIdentifier: GameTopCollectionViewCell.identifier)
    gamesTopCollectionView.register(ShimmerGamesTopCollectionViewCell.nib(),
                                    forCellWithReuseIdentifier: ShimmerGamesTopCollectionViewCell.identifier)
    gamesTopCollectionView.register(GamesTopFooterCollectionReusableView.nib(),
                                    forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                    withReuseIdentifier: GamesTopFooterCollectionReusableView.identifier)
    gamesTopCollectionView.delegate = self
    gamesTopCollectionView.dataSource = self
  }
  
  private func updateTableView() {
    DispatchQueue.main.async {
      if self.listGamesByQuery.isEmpty {
        self.gamesTableView.setBackgroundViewWithImage(image: UIImage(named: "icon_error_search"),
                                                       message: "Game \"\(self.querySearch)\" not found!",
                                                       insideScrollView: true)
      } else {
        self.gamesTableView.restore(separator: .singleLine)
      }
      self.gamesTableView.reloadData()
    }
  }
  
  private func setEmptyTableView() {
    DispatchQueue.main.async {
      self.listGamesByQuery.removeAll()
      self.gamesTableView.setBackgroundViewWithImage(image: UIImage(named: "icon_search"),
                                                     message: "Waiting to search ...",
                                                     insideScrollView: true)
      self.gamesTableView.reloadData()
    }
  }
  
  private func updateCollectionView() {
    DispatchQueue.main.async {
      self.gamesTopCollectionView.reloadData()
    }
  }
  
  private func navigateToDetailGame(id: Int) {
    let detailVC = DetailGameViewController(nibName: "DetailGameViewController", bundle: nil)
    detailVC.gameID = id
    self.navigationController?.pushViewController(detailVC, animated: true)
  }
  
  @objc private func navigateToSeeAllGamesTop() {
    let listGameVC = ListGamesViewController(nibName: "ListGamesViewController", bundle: nil)
    listGameVC.titleTable = "Top Rated"
    listGameVC.gameType = GameType.topRated
    self.navigationController?.pushViewController(listGameVC, animated: true)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationItem.largeTitleDisplayMode = .always
    tabBarController?.tabBar.isHidden = false
  }
}

// MARK: TableView
extension GamesViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch stateTableView {
    case .loading:
      return 8
    case .showing:
      if onSearch {
        return listGamesByQuery.count
      } else {
        return listGames.count
      }
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch stateTableView {
    case .loading:
      guard let cell = tableView.dequeueReusableCell(
              withIdentifier: ShimmerGameTableViewCell.identifier, for: indexPath) as? ShimmerGameTableViewCell else {
        return UITableViewCell()
      }
      cell.selectionStyle = .none
      return cell
    case .showing:
      guard let cell = tableView.dequeueReusableCell(
              withIdentifier: GameTableViewCell.identifier, for: indexPath) as? GameTableViewCell else {
        return UITableViewCell()
      }
      
      let game: Game
      if onSearch {
        game = self.listGamesByQuery[indexPath.row]
      } else {
        game = self.listGames[indexPath.row]
      }
      cell.configureCell(game)
      cell.selectionStyle = .none
      return cell
    }
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    guard let header = gamesTableView.dequeueReusableHeaderFooterView(
            withIdentifier: HeaderGamesTableView.identifier) as? HeaderGamesTableView else {
      return nil
    }
    if onSearch {
      header.configureContents(title: "List Game \"\(querySearch)\"")
    } else {
      header.configureContents(title: "All Lists")
    }
    return header
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    if onSearch {
      if querySearch.isEmpty {
        return 0
      } else {
        return 50
      }
    } else {
      return 50
    }
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    scrollView.layoutIfNeeded()
    heightTable.constant = gamesTableView.contentSize.height
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if stateTableView == StateView.showing {
      if onSearch {
        navigateToDetailGame(id: listGamesByQuery[indexPath.row].id)
      } else {
        navigateToDetailGame(id: listGames[indexPath.row].id)
      }
    }
  }
}

// MARK: CollectionView
extension GamesViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    switch stateCollectionView {
    case .loading:
      return 3
    case .showing:
      return listGamesTop.count
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    switch stateCollectionView {
    case .loading:
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShimmerGamesTopCollectionViewCell.identifier, for: indexPath) as? ShimmerGamesTopCollectionViewCell else {
        return UICollectionViewCell()
      }
      return cell
    case .showing:
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GameTopCollectionViewCell.identifier, for: indexPath) as? GameTopCollectionViewCell else {
        return UICollectionViewCell()
      }
      cell.configureCell(listGamesTop[indexPath.row])
      return cell
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: screenSize.width - 60, height: 220)
  }
  
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    switch kind {
    case UICollectionView.elementKindSectionFooter:
      let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: GamesTopFooterCollectionReusableView.identifier, for: indexPath)
      
      let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(navigateToSeeAllGamesTop))
      footerView.addGestureRecognizer(tapGestureRecognizer)
      return footerView
    default:
      fatalError("Unexpected element kind")
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
    switch stateCollectionView {
    case .loading:
      return CGSize.zero
    case .showing:
      return CGSize(width: 160, height: 0)
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if stateCollectionView == StateView.showing {
      navigateToDetailGame(id: listGamesTop[indexPath.row].id)
    }
  }
}

// MARK: Search
extension GamesViewController: UISearchResultsUpdating, UISearchControllerDelegate {
  func didPresentSearchController(_ searchController: UISearchController) {
    onSearch = true
    headerTop.isHidden = true
    gamesTopCollectionView.isHidden = true
    tabBarController?.tabBar.isHidden = true
    setEmptyTableView()
  }
  
  func didDismissSearchController(_ searchController: UISearchController) {
    onSearch = false
    headerTop.isHidden = false
    gamesTopCollectionView.isHidden = false
    tabBarController?.tabBar.isHidden = false
    DispatchQueue.main.async {
      self.gamesTableView.reloadData()
    }
  }
  
  func updateSearchResults(for searchController: UISearchController) {
    guard var searchText = searchController.searchBar.text else {
      return
    }
    searchText = searchText.trimmingCharacters(in: .whitespaces)
    if self.querySearch == searchText {
      return
    }
    self.querySearch = searchText
    
    if self.querySearch.isEmpty {
      setEmptyTableView()
      debouncer.cancel()
    } else {
      debouncer.call()
    }
  }
}

