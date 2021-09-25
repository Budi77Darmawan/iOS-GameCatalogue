//
//  ShimmerGameTableViewCell.swift
//  Game Catalogue
//
//  Created by Budi Darmawan on 25/09/21.
//

import UIKit

class ShimmerGameTableViewCell: UITableViewCell {
  static let identifier = "ShimmerGameTableViewCell"
  static func nib() -> UINib {
    return UINib(nibName: "ShimmerGameTableViewCell",
                 bundle: nil)
  }
  
  @IBOutlet weak var rootView: ShimmerView!
  @IBOutlet weak var imgView: ShimmerView!
  @IBOutlet weak var tvTitle: ShimmerView!
  @IBOutlet weak var tvReleased: ShimmerView!
  @IBOutlet weak var tvRating: ShimmerView!
  let screenSize = UIScreen.main.bounds
  
  override func awakeFromNib() {
    super.awakeFromNib()
    rootView.cornerRadius(10)
    imgView.cornerRadius(6)
    tvTitle.frame = CGRect(x: 0, y: 0, width: screenSize.width/1.75, height: 22)
    tvReleased.frame = CGRect(x: 0, y: 0, width: tvTitle.frame.size.width/2, height: 16)
    tvRating.frame = CGRect(x: 0, y: 0, width: (tvReleased.frame.size.width*3.5)/4, height: 16)
    
    rootView.startAnimating(color: ShimmerColor.root)
    imgView.startAnimating(color: ShimmerColor.primary)
    tvTitle.startAnimating(color: ShimmerColor.primary)
    tvReleased.startAnimating(color: ShimmerColor.secondary)
    tvRating.startAnimating(color: ShimmerColor.secondary)
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
