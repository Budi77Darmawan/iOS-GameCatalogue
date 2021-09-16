//
//  HeaderGamesTableView.swift
//  Game Catalogue
//
//  Created by Budi Darmawan on 08/09/21.
//

import UIKit

class HeaderGamesTableView: UITableViewHeaderFooterView {
  static let identifier = "HeaderGamesTableView"
  static func nib() -> UINib {
    return UINib(nibName: "HeaderGamesTableView",
                 bundle: nil)
  }
  
  @IBOutlet weak var tvTitle: UILabel!
  @IBOutlet weak var iconCapsule: UIImageView!
  
  func configureContents(title: String) {
    tvTitle.text = title
    iconCapsule.backgroundColor = .systemBlue
    iconCapsule.rounded(4)
  }
}
