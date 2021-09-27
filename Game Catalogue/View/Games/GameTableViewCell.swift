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
  @IBOutlet weak var imgGame: UIImageView!
  @IBOutlet weak var tvTitle: UILabel!
  @IBOutlet weak var tvReleased: UILabel!
  @IBOutlet weak var tvRatingCount: UILabel!
  @IBOutlet weak var imgRating: UIImageView!
  @IBOutlet weak var iconNext: UIImageView!
  
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
    imgGame.rounded(10)
    iconNext.image = UIImage(systemName: "chevron.right")
    iconNext.tintColor = .gray
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
