//
//  ViiewExt.swift
//  Game Catalogue
//
//  Created by Budi Darmawan on 27/09/21.
//

import Foundation
import UIKit

extension UIView {
  
  func makeRounded() {
    self.layer.cornerRadius = self.frame.height / 2
    self.clipsToBounds = true
    self.layer.borderWidth = 0.6
    self.layer.borderColor = UIColor.darkGray.cgColor
  }
  
  func cornerRadius(_ radius: CGFloat) {
    self.layer.cornerRadius = radius
    self.clipsToBounds = true
  }
  
  func makeShadow(_ radius: CGFloat = 3, _ opacity: Float = 0.5) {
    self.layer.shadowOffset = CGSize(width: 3, height: 3)
    self.layer.shadowRadius = radius
    self.layer.shadowOpacity = opacity
    self.clipsToBounds = false
  }
  
  func visible() {
    self.isHidden = false
  }
  
  func gone() {
    self.isHidden = true
  }
}
