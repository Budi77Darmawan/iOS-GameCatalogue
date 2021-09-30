//
//  ViiewExt.swift
//  Game Catalogue
//
//  Created by Budi Darmawan on 27/09/21.
//

import Foundation
import UIKit

extension UIView {
  func cornerRadius(_ radius: CGFloat) {
    self.layer.cornerRadius = radius
    self.clipsToBounds = true
  }
  
  func visible() {
    self.isHidden = false
  }
  
  func gone() {
    self.isHidden = true
  }
}
