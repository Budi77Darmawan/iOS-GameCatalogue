//
//  DetailGameViewController.swift
//  Game Catalogue
//
//  Created by Budi Darmawan on 16/09/21.
//

import UIKit
import RealmSwift
import Toast_Swift

struct AttributDetailGame {
  let title: String
  let value: String
}

class DetailGameViewController: UIViewController {
  
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var imgGame: UIImageView!
  @IBOutlet weak var tvTitle: UILabel!
  @IBOutlet weak var btnBookmark: UIButton!
  @IBOutlet weak var tvDescription: UILabel!
  @IBOutlet weak var detailCollectionView: UICollectionView!
  @IBOutlet weak var collectionHeight: NSLayoutConstraint!
  
  var gameID: Int? = nil
  var isBookmark = false
  private let screenSize: CGRect = UIScreen.main.bounds
  private lazy var gamesViewModel: GamesViewModel! = {
    return GamesViewModel()
  }()
  private var attributDetailGame = [AttributDetailGame]()
  private var detailGame: DetailGame? = nil
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    checkDatabase()
    initCollectionView()
  }
  
  private func checkDatabase() {
    guard let id = gameID else {
      return
    }
    
    let detailDB = DatabaseCall.getGameById(id: id)
    if detailDB != nil {
      detailGame = detailDB
      isBookmark = true
      guard let detail = detailGame else { return }
      setupView(detail: detail)
    } else {
      observerDetailGame()
      gamesViewModel.getDetailGameById(id: id)
      isBookmark = false
    }
    setupButtonBookmark()
  }
  
  private func observerDetailGame() {
    gamesViewModel.detailGame.bind { detailGame in
      switch detailGame {
      case .loading:
        self.view.makeToastActivity(.center)
      case .error(_, _):
        self.scrollView.hideToastActivity()
      case .success(let data):
        DispatchQueue.main.async {
          guard let detail = data else { return }
          self.detailGame = detail
          self.setupView(detail: detail)
          self.view.hideToastActivity()
        }
      case .none:
        break
      }
    }
  }
  
  private func initCollectionView() {
    detailCollectionView.register(DetailCollectionViewCell.nib(),
                                  forCellWithReuseIdentifier: DetailCollectionViewCell.identifier)
    detailCollectionView.delegate = self
    detailCollectionView.dataSource = self
  }
  
  private func setupView(detail: DetailGame) {
    self.title = detail.name
    tvTitle.text = detail.name
    let description = detail.description.isEmpty ? "No Description" : (detail.description)
    tvDescription.text = description
      .replacingOccurrences(of: "\r\n", with:"" )
      .replacingOccurrences(of: "\n\n", with:"\n" )
    imgGame.setImage(detail.backgroundImage)
    btnBookmark.addTarget(self, action: #selector(updateStatusGame), for: .touchUpInside)
    
    let rating = detail.rating != nil ? String(detail.rating ?? 0) : "-"
    let ratingCount = detail.ratingCount != nil ? String(detail.ratingCount ?? 0) : "0"
    let metascore = detail.metacritic != nil ? String(detail.metacritic ?? 0) : "-"
    
    self.attributDetailGame.append(AttributDetailGame(title: "Rating", value: "\(rating) (\(ratingCount) votes)"))
    self.attributDetailGame.append(AttributDetailGame(title: "Metascore", value: "\(metascore)"))
    self.attributDetailGame.append(AttributDetailGame(title: "Platform", value: ConvertType.listPlatformsToString(list: detail.parentPlatforms)))
    self.attributDetailGame.append(AttributDetailGame(title: "Genre", value: ConvertType.listGenresToString(list: detail.genres)))
    self.attributDetailGame.append(AttributDetailGame(title: "Release Date", value: ConvertDate.formatDate(date: detail.released ?? "")))
    self.attributDetailGame.append(AttributDetailGame(title: "Developer", value: ConvertType.listDevelopersToString(list: detail.developers)))
    self.attributDetailGame.append(AttributDetailGame(title: "Publisher", value: ConvertType.listPublishersToString(list: detail.publishers)))
    self.attributDetailGame.append(AttributDetailGame(title: "Age Rating", value: detail.esrbRating?.name ?? "-"))
    
    self.detailCollectionView.reloadData()
  }
  
  @objc
  private func updateStatusGame() {
    guard let detail = detailGame else { return }
    if isBookmark {
      let stateDelete = DatabaseCall.deleteFromDatabase(gameId: detail.id)
      if stateDelete {
        isBookmark = !isBookmark
        self.view.makeToast("Has been removed from bookmarks")
      }
    } else {
      let stateAdd = DatabaseCall.addToDatabase(game: detail)
      if stateAdd {
        isBookmark = !isBookmark
        self.view.makeToast("Successfully added to bookmarks")
      }
    }
    setupButtonBookmark()
  }
  
  private func setupButtonBookmark() {
    if isBookmark {
      btnBookmark.setTitle("Bookmarked", for: .normal)
      btnBookmark.setTitleColor(.white, for: .normal)
      btnBookmark.setImage(UIImage(systemName: "bookmark"), for: .normal)
      btnBookmark.tintColor = .white
      btnBookmark.backgroundColor = .systemBlue
    } else {
      btnBookmark.setTitle("Add to Bookmark", for: .normal)
      btnBookmark.setTitleColor(.systemBlue, for: .normal)
      btnBookmark.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
      btnBookmark.tintColor = .systemBlue
      btnBookmark.backgroundColor = .clear
    }
    btnBookmark.cornerRadius(8)
    btnBookmark.layer.borderWidth = 1
    btnBookmark.layer.borderColor = UIColor.systemBlue.cgColor
  }
  
  override func viewWillAppear(_ animated: Bool) {
    title = "Detail Game"
    navigationItem.largeTitleDisplayMode = .never
    tabBarController?.tabBar.isHidden = true
  }
}

// MARK: CollectionVIew
extension DetailGameViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return attributDetailGame.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailCollectionViewCell.identifier, for: indexPath) as? DetailCollectionViewCell else {
      return UICollectionViewCell()
    }
    cell.tvTitle.text = attributDetailGame[indexPath.row].title
    cell.tvValue.text = attributDetailGame[indexPath.row].value
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = itemWidth(for: screenSize.width, spacing: 10)
    return CGSize(width: width, height: 60)
  }
  
  func itemWidth(for width: CGFloat, spacing: CGFloat) -> CGFloat {
    let itemsInRow: CGFloat = 2
    let totalSpacing: CGFloat = 2 * spacing + (itemsInRow - 1) * spacing
    let finalWidth = (width - totalSpacing) / itemsInRow
    return finalWidth - 5.0
  }
  
  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    collectionHeight.constant = detailCollectionView.contentSize.height
  }
  
}
