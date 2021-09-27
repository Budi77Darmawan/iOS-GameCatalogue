//
//  ViiewExt.swift
//  Game Catalogue
//
//  Created by Budi Darmawan on 27/09/21.
//

import Foundation
import UIKit

extension UIView {
  func cornerRadius(_ radius: CGFloat = 0) {
    self.layer.cornerRadius = radius
    self.clipsToBounds = true
  }
}
