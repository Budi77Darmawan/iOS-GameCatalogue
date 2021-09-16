//
//  ProfileViewController.swift
//  Game Catalogue
//
//  Created by Budi Darmawan on 10/07/21.
//

import UIKit

class GamesViewController: UIViewController {
  
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var gamesTopCollectionView: UICollectionView!
  @IBOutlet weak var gamesTableView: UITableView!
  @IBOutlet weak var heightTable: NSLayoutConstraint!
  @IBOutlet weak var widthStack: NSLayoutConstraint!
  @IBOutlet weak var iconCapsule: UIImageView!
  @IBOutlet weak var tvGamesType: UILabel!
  
  private var gamesViewModel: GamesViewModel!
  private var listGames: [Game] = [Game]()
  private var listGamesTop: [Game] = [Game]()
  private let screenSize: CGRect = UIScreen.main.bounds
  
  override func viewDidLoad() {
    super.viewDidLoad()
    initView()
    initTableView()
    initCollectionView()
    
    gamesViewModel = GamesViewModel()
    gamesViewModel.getDataGames()
    gamesViewModel.getGamesTopRated()
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
          self.listGamesTop.append(contentsOf: Array(results.prefix(5)))
          self.gamesTopCollectionView.reloadData()
        }
      }
    }
    
    func initView() {
      widthStack.constant = screenSize.width
      tvGamesType.text = "Top Rated"
      iconCapsule.backgroundColor = .systemBlue
      iconCapsule.rounded(4)
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
    
    func initCollectionView() {
      gamesTopCollectionView.register(GameTopCollectionViewCell.nib(),
                                      forCellWithReuseIdentifier: GameTopCollectionViewCell.identifier)
      gamesTopCollectionView.register(GamesTopFooterCollectionReusableView.nib(),
                                      forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: GamesTopFooterCollectionReusableView.identifier)
      gamesTopCollectionView.delegate = self
      gamesTopCollectionView.dataSource = self
    }
  }
  
  @objc func navigateToSeeAllGamesTop() {
    let listGameVC = ListGamesViewController(nibName: "ListGamesViewController", bundle: nil)
    listGameVC.titleTable = "Top Rated"
    listGameVC.gameType = GameType.topRated
    self.navigationController?.pushViewController(listGameVC, animated: true)
  }
  
}

// MARK: TableView
extension GamesViewController: UITableViewDataSource, UITableViewDelegate {
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
}

// MARK: CollectionVIew
extension GamesViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return listGamesTop.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GameTopCollectionViewCell.identifier, for: indexPath) as? GameTopCollectionViewCell else {
      return UICollectionViewCell()
    }
    cell.configureCell(listGamesTop[indexPath.row])
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
    if listGamesTop.isEmpty {
      return CGSize.zero
    } else {
      return CGSize(width: 160, height: 0)
    }
  }
}
