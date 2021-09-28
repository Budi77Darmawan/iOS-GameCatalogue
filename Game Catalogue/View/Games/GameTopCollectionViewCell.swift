//
//  GameTopCollectionViewCell.swift
//  Game Catalogue
//
//  Created by Budi Darmawan on 11/09/21.
//

import UIKit

class GameTopCollectionViewCell: UICollectionViewCell {
  
  static let identifier = "GameTopCollectionViewCell"
  static func nib() -> UINib {
    return UINib(nibName: "GameTopCollectionViewCell",
                 bundle: nil)
  }
  
  @IBOutlet weak var imgGame: UIImageView!
  @IBOutlet weak var tvTitle: UILabel!
  
  private var shimmerImage = ShimmerView()
  private var shimmerTitle = ShimmerView()
  
  override func awakeFromNib() {
    super.awakeFromNib()
    imgGame.rounded(10)
    tvTitle.layer.cornerRadius = 5
    tvTitle.layer.masksToBounds = true
  }
  
  func configureCell(_ game: Game) {
    tvTitle.text = game.name
    imgGame.setImage(game.backgroundImage)
  }
  
  func state(_ stateView: StateView) -> Bool {
      switch stateView {
      case .loading:
        setLoadingState()
        return false
      case .showing:
        removeLoadingState()
        return true
      }
    }
    
    private func setLoadingState() {
      shimmerImage.translatesAutoresizingMaskIntoConstraints = false
      shimmerTitle.translatesAutoresizingMaskIntoConstraints = false
      shimmerImage.cornerRadius(10)
      shimmerTitle.cornerRadius(5)
      
      self.addSubview(shimmerImage)
      self.addSubview(shimmerTitle)
      
      NSLayoutConstraint.activate([
        shimmerImage.topAnchor.constraint(equalTo: imgGame.topAnchor, constant: 0),
        shimmerImage.leadingAnchor.constraint(equalTo: imgGame.leadingAnchor, constant: 0),
        shimmerImage.bottomAnchor.constraint(equalTo: imgGame.bottomAnchor, constant: 0),
        shimmerImage.trailingAnchor.constraint(equalTo: imgGame.trailingAnchor, constant: 0),
        shimmerTitle.topAnchor.constraint(equalTo: tvTitle.topAnchor, constant: 0),
        shimmerTitle.leadingAnchor.constraint(equalTo: tvTitle.leadingAnchor, constant: 0),
        shimmerTitle.bottomAnchor.constraint(equalTo: tvTitle.bottomAnchor, constant: 0),
        shimmerTitle.widthAnchor.constraint(equalTo: imgGame.widthAnchor, multiplier: 0.75)
      ])
    
      shimmerImage.startAnimating(color: .secondary)
      shimmerTitle.startAnimating(color: .primary)
    }
    
    private func removeLoadingState() {
      shimmerImage.removeFromSuperview()
      shimmerTitle.removeFromSuperview()
    }
}
