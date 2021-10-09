//
//  ImageViewExt.swift
//  Game Catalogue
//
//  Created by Budi Darmawan on 27/08/21.
//

import Foundation
import Kingfisher

extension UIImageView {

  func setImage(_ imageURL: String?) {
    guard let urlImage = imageURL else {
      let urlImage = URL(string: Const.defaultUriImage)
      self.kf.setImage(with: urlImage)
      return
    }
    self.kf.setImage(with: URL(string: urlImage))
  }
  
}
