//
//  ShimmerView.swift
//  Game Catalogue
//
//  Created by Budi Darmawan on 25/09/21.
//

import Foundation
import UIKit

class ShimmerView: UIView {
  private let gradient : CAGradientLayer = CAGradientLayer()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  override func layoutSublayers(of layer: CALayer) {
    super.layoutSublayers(of: layer)
    gradient.frame = self.bounds
  }
  
  override func draw(_ rect: CGRect) {
    super.draw(rect)
    gradient.frame = self.bounds
    gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
    gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
    gradient.locations = [0.0, 0.5, 1.0]
    self.layer.addSublayer(gradient)
    if gradient.superlayer == nil {
      layer.insertSublayer(gradient, at: 0)
    }
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
    let animation = addAnimation()
    gradient.colors = [colorOne, colorTwo, colorOne]
    gradient.add(animation, forKey: animation.keyPath)
  }
}
