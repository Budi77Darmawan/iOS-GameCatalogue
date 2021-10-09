//
//  GameTableViewCell.swift
//  Game Catalogue
//
//  Created by Budi Darmawan on 05/09/21.
//

import UIKit

class GameTableViewCell: UITableViewCell {
  
  static let identifier = "GameTableViewCell"
  static func nib() -> UINib {
    return UINib(nibName: "GameTableViewCell",
                 bundle: nil)
  }
  @IBOutlet weak var rootStack: UIStackView!
  @IBOutlet weak var imgGame: UIImageView!
  @IBOutlet weak var tvTitle: UILabel!
  @IBOutlet weak var tvReleased: UILabel!
  @IBOutlet weak var tvRatingCount: UILabel!
  @IBOutlet weak var imgRating: UIImageView!
  @IBOutlet weak var iconNext: UIImageView!
  
  private var shimmer = UIView()
  private var shimmerRoot = ShimmerView()
  private var shimmerImage = ShimmerView()
  private var shimmerTitle = ShimmerView()
  private var shimmerReleased = ShimmerView()
  private var shimmerRating = ShimmerView()
  
  func configureCell(_ game: Game) {
    tvTitle.text = game.name
    let ratingCount = game.ratingCount == nil ? "(0)" : "(\(game.ratingCount ?? 0))"
    tvRatingCount.text = ratingCount
    
    let date = game.released == nil ? "-" : ConvertDate.formatDate(date: game.released ?? "")
    tvReleased.text = "Released: \(date)"
    imgGame.setImage(game.backgroundImage)
  }
  
  func configureCell(_ game: DetailGame) {
    tvTitle.text = game.name
    let ratingCount = game.ratingCount == nil ? "(0)" : "(\(game.ratingCount ?? 0))"
    tvRatingCount.text = ratingCount
    
    let date = game.released == nil ? "-" : ConvertDate.formatDate(date: game.released ?? "")
    tvReleased.text = "Released: \(date)"
    imgGame.setImage(game.backgroundImage)
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    imgGame.cornerRadius(10)
    iconNext.image = UIImage(systemName: "chevron.right")
    iconNext.tintColor = .gray
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  func state(_ stateView: StateView, _ withShimmer: Bool = true) -> Bool {
    if withShimmer {
      switch stateView {
      case .loading:
        setLoadingState()
        return false
      case .showing:
        removeLoadingState()
        return true
      }
    } else {
      return true
    }
  }
  
  private func setLoadingState() {
    iconNext.visible()
    shimmer.translatesAutoresizingMaskIntoConstraints = false
    shimmerRoot.translatesAutoresizingMaskIntoConstraints = false
    shimmerImage.translatesAutoresizingMaskIntoConstraints = false
    shimmerTitle.translatesAutoresizingMaskIntoConstraints = false
    shimmerReleased.translatesAutoresizingMaskIntoConstraints = false
    shimmerRating.translatesAutoresizingMaskIntoConstraints = false
    shimmer.cornerRadius(10)
    shimmerRoot.cornerRadius(10)
    shimmerImage.cornerRadius(5)
    shimmerTitle.cornerRadius(3)
    shimmerReleased.cornerRadius(2)
    shimmerRating.cornerRadius(2)
    
    self.addSubview(shimmer)
    self.addSubview(shimmerRoot)
    self.addSubview(shimmerImage)
    self.addSubview(shimmerTitle)
    self.addSubview(shimmerReleased)
    self.addSubview(shimmerRating)
    
    NSLayoutConstraint.activate([
      shimmer.topAnchor.constraint(equalTo: rootStack.topAnchor, constant: 0),
      shimmer.leadingAnchor.constraint(equalTo: rootStack.leadingAnchor, constant: 0),
      shimmer.bottomAnchor.constraint(equalTo: rootStack.bottomAnchor, constant: 0),
      shimmer.trailingAnchor.constraint(equalTo: rootStack.trailingAnchor, constant: 0),
      shimmerRoot.topAnchor.constraint(equalTo: rootStack.topAnchor, constant: 0),
      shimmerRoot.leadingAnchor.constraint(equalTo: rootStack.leadingAnchor, constant: 0),
      shimmerRoot.bottomAnchor.constraint(equalTo: rootStack.bottomAnchor, constant: 0),
      shimmerRoot.trailingAnchor.constraint(equalTo: rootStack.trailingAnchor, constant: 0),
      shimmerImage.topAnchor.constraint(equalTo: imgGame.topAnchor, constant: 10),
      shimmerImage.leadingAnchor.constraint(equalTo: imgGame.leadingAnchor, constant: 10),
      shimmerImage.bottomAnchor.constraint(equalTo: imgGame.bottomAnchor, constant: -10),
      shimmerImage.trailingAnchor.constraint(equalTo: imgGame.trailingAnchor, constant: -10),
      shimmerTitle.topAnchor.constraint(equalTo: tvTitle.topAnchor, constant: 1),
      shimmerTitle.leadingAnchor.constraint(equalTo: tvTitle.leadingAnchor, constant: 0),
      shimmerTitle.bottomAnchor.constraint(equalTo: tvTitle.bottomAnchor, constant: -1),
      shimmerTitle.widthAnchor.constraint(equalTo: rootStack.widthAnchor, multiplier: 0.55),
      shimmerReleased.topAnchor.constraint(equalTo: tvReleased.topAnchor, constant: 1),
      shimmerReleased.leadingAnchor.constraint(equalTo: tvReleased.leadingAnchor, constant: 0),
      shimmerReleased.bottomAnchor.constraint(equalTo: tvReleased.bottomAnchor, constant: -1),
      shimmerReleased.widthAnchor.constraint(equalTo: shimmerTitle.widthAnchor, multiplier: 0.7),
      shimmerRating.topAnchor.constraint(equalTo: tvRatingCount.topAnchor, constant: 1),
      shimmerRating.leadingAnchor.constraint(equalTo: tvReleased.leadingAnchor, constant: 0),
      shimmerRating.bottomAnchor.constraint(equalTo: tvRatingCount.bottomAnchor, constant: -1),
      shimmerRating.widthAnchor.constraint(equalTo: shimmerReleased.widthAnchor, multiplier: 0.55)
    ])
    
    shimmer.backgroundColor = .white
    shimmerRoot.startAnimating(color: .root)
    shimmerImage.startAnimating(color: .primary)
    shimmerTitle.startAnimating(color: .primary)
    shimmerReleased.startAnimating(color: .secondary)
    shimmerRating.startAnimating(color: .secondary)
  }
  
  private func removeLoadingState() {
    iconNext.gone()
    shimmer.removeFromSuperview()
    shimmerRoot.removeFromSuperview()
    shimmerImage.removeFromSuperview()
    shimmerTitle.removeFromSuperview()
    shimmerReleased.removeFromSuperview()
    shimmerRating.removeFromSuperview()
  }
  
}
