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
  
}
