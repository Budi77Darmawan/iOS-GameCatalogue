//
//  GamesTopFooterCollectionReusableView.swift
//  Game Catalogue
//
//  Created by Budi Darmawan on 15/09/21.
//

import UIKit

class GamesTopFooterCollectionReusableView: UICollectionReusableView {
  static let identifier = "GamesTopFooterCollectionReusableView"
  static func nib() -> UINib {
    return UINib(nibName: "GamesTopFooterCollectionReusableView",
                 bundle: nil)
  }
  
  @IBOutlet weak var iconSeeAll: UIImageView!
  @IBOutlet weak var tvSeeAll: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    tvSeeAll.text = "See All"
    iconSeeAll.image = UIImage(systemName: "chevron.right.circle")
    iconSeeAll.tintColor = .systemBlue
  }
  
}
