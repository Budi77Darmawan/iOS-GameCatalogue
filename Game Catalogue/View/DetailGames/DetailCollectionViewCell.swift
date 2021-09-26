//
//  DetailCollectionViewCell.swift
//  Game Catalogue
//
//  Created by Budi Darmawan on 17/09/21.
//

import UIKit

class DetailCollectionViewCell: UICollectionViewCell {
  static let identifier = "DetailCollectionViewCell"
  static func nib() -> UINib {
    return UINib(nibName: "DetailCollectionViewCell",
                 bundle: nil)
  }
  @IBOutlet weak var tvTitle: UILabel!
  @IBOutlet weak var tvValue: UILabel!
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
