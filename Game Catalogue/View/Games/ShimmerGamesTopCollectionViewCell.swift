//
//  ShimmerGamesTopCollectionViewCell.swift
//  Game Catalogue
//
//  Created by Budi Darmawan on 25/09/21.
//

import UIKit

class ShimmerGamesTopCollectionViewCell: UICollectionViewCell {
  
  static let identifier = "ShimmerGamesTopCollectionViewCell"
  static func nib() -> UINib {
    return UINib(nibName: "ShimmerGamesTopCollectionViewCell",
                 bundle: nil)
  }
  
  @IBOutlet weak var imgView: ShimmerView!
  @IBOutlet weak var tvTitile: ShimmerView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    imgView.cornerRadius(15)
    tvTitile.cornerRadius(5)
    
    imgView.startAnimating(color: ShimmerColor.secondary)
    tvTitile.startAnimating(color: ShimmerColor.primary)
  }
  
}
