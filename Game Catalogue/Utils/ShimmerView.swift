//
//  ShimmerView.swift
//  Game Catalogue
//
//  Created by Budi Darmawan on 25/09/21.
//

import Foundation
import UIKit

class ShimmerView: UIView {
  private func addGradientLayer(
    _ colorOne: CGColor,
    _ colorTwo: CGColor
  ) -> CAGradientLayer {
    let gradientLayer = CAGradientLayer()
    gradientLayer.frame = self.bounds
    gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
    gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
    gradientLayer.colors = [colorOne, colorTwo, colorOne]
    gradientLayer.locations = [0.0, 0.5, 1.0]
    self.layer.addSublayer(gradientLayer)
    return gradientLayer
  }
  
  private func addAnimation() -> CABasicAnimation {
    let animation = CABasicAnimation(keyPath: "locations")
    animation.fromValue = [-1.0, -0.5, 0.0]
    animation.toValue = [1.0, 1.5, 2.0]
    animation.repeatCount = .infinity
    animation.duration = 1.0
    return animation
  }
  
  func startAnimating(color: ShimmerColor) {
    var colorOne = UIColor(white: 0.85, alpha: 1.0).cgColor
    var colorTwo = UIColor(white: 0.95, alpha: 1.0).cgColor

    switch color {
    case .root:
      colorOne = UIColor(white: 0.92, alpha: 0.5).cgColor
      colorTwo = UIColor(white: 0.95, alpha: 0.5).cgColor
    case .primary:
      colorOne = UIColor(white: 0.65, alpha: 1.0).cgColor
      colorTwo = UIColor(white: 0.75, alpha: 1.0).cgColor
    case .secondary:
      colorOne = UIColor(white: 0.85, alpha: 1.0).cgColor
      colorTwo = UIColor(white: 0.9, alpha: 1.0).cgColor
    }
    
    
    let gradientLayer = addGradientLayer(colorOne, colorTwo)
    let animation = addAnimation()
    gradientLayer.add(animation, forKey: animation.keyPath)
  }
  
}
