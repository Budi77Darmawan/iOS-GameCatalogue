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
  @IBOutlet weak var iconCapsule: UIImageView!
  @IBOutlet weak var tvGamesType: UILabel!
  
  private let searchController = UISearchController(searchResultsController: SearchGamesViewController())
  private lazy var gamesViewModel: GamesViewModel = {
    return GamesViewModel()
  }()
  
  private var listGames: [Game] = [Game]()
  private var listGamesTop: [Game] = [Game]()
  private let screenSize: CGRect = UIScreen.main.bounds
  private var stateTableView = StateView.loading
  private var stateCollectionView = StateView.loading
  private var onSearch = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    searchController.delegate = self
    searchController.searchResultsUpdater = self
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.showsSearchResultsController = true
    navigationItem.searchController = searchController
    navigationItem.hidesSearchBarWhenScrolling = false
    
    initView()
    initTableView()
    initCollectionView()
    observerViewModel()
  }
  
  private func observerViewModel() {
    gamesViewModel.listGames.bind { games in
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
    
    gamesViewModel.listGamesTopRated.bind { games in
      switch games {
      case .loading:
        self.stateCollectionView = .loading
        self.updateCollectionView()
      case .error(let msg, _):
        print(msg ?? "ERROR")
      case .success(let data):
        self.stateCollectionView = .showing
        let results = data?.results ?? []
        self.listGamesTop.append(contentsOf: Array(results.prefix(5)))
        self.updateCollectionView()
      case .none:
        break
      }
    }
    
    gamesViewModel.getDataGames()
    gamesViewModel.getGamesTopRated()
  }
  
  private func initView() {
    tvGamesType.text = "Top Rated"
    iconCapsule.backgroundColor = .systemBlue
    iconCapsule.cornerRadius(4)
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
  
  private func initCollectionView() {
    gamesTopCollectionView.register(GameTopCollectionViewCell.nib(),
                                    forCellWithReuseIdentifier: GameTopCollectionViewCell.identifier)
    gamesTopCollectionView.register(GamesTopFooterCollectionReusableView.nib(),
                                    forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                    withReuseIdentifier: GamesTopFooterCollectionReusableView.identifier)
    gamesTopCollectionView.delegate = self
    gamesTopCollectionView.dataSource = self
  }
  
  private func updateTableView() {
    DispatchQueue.main.async {
      self.gamesTableView.restore(separator: .singleLine)
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
    let tabBarHide = onSearch ? true : false
    tabBarController?.tabBar.isHidden = tabBarHide
  }
}

// MARK: TableView
extension GamesViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return stateTableView == .loading ? 8 : listGames.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    guard let cell = tableView.dequeueReusableCell(
            withIdentifier: GameTableViewCell.identifier, for: indexPath) as? GameTableViewCell else {
      return UITableViewCell()
    }
    
    if cell.state(stateTableView) {
      let game: Game
      game = self.listGames[indexPath.row]
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
    header.configureContents(title: "All Lists")
    return header
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 50
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    scrollView.layoutIfNeeded()
    heightTable.constant = gamesTableView.contentSize.height
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if stateTableView == .showing {
      navigateToDetailGame(id: listGames[indexPath.row].id)
    }
  }
}

// MARK: CollectionView
extension GamesViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return stateCollectionView == .loading ? 5 : listGamesTop.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GameTopCollectionViewCell.identifier, for: indexPath) as? GameTopCollectionViewCell else {
      return UICollectionViewCell()
    }
    if cell.state(stateCollectionView) {
      cell.configureCell(listGamesTop[indexPath.row])
    }
    return cell
    
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
    tabBarController?.tabBar.isHidden = true
    if let controller = searchController.searchResultsController as? SearchGamesViewController {
      controller.delegateSearchProtocol(self)
    }
  }
  
  func didDismissSearchController(_ searchController: UISearchController) {
    onSearch = false
    tabBarController?.tabBar.isHidden = false
  }
  
  func updateSearchResults(for searchController: UISearchController) {
    guard let searchText = searchController.searchBar.text else {
      return
    }
    if let controller = searchController.searchResultsController as? SearchGamesViewController {
      controller.searchGames(querySearch: searchText)
    }
  }
}

// MARK: Search Protocol
extension GamesViewController: SearchProtocol {
  func onClickItem(id: Int) {
    navigateToDetailGame(id: id)
  }
  
}

