//
//  TableViewExt.swift
//  Game Catalogue
//
//  Created by Budi Darmawan on 27/09/21.
//

import Foundation
import UIKit

extension UITableView {
  
  func setBackgroundViewWithImage(image: UIImage?, message: String) {
    let parentView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
    
    let messageImageView = UIImageView()
    let messageLabel = UILabel()
    
    messageImageView.backgroundColor = .clear
    
    messageLabel.translatesAutoresizingMaskIntoConstraints = false
    messageImageView.translatesAutoresizingMaskIntoConstraints = false
    
    messageLabel.textColor = .gray
    messageLabel.font = UIFont.systemFont(ofSize: 16)
    
    parentView.addSubview(messageLabel)
    parentView.addSubview(messageImageView)
    
    messageImageView.centerXAnchor.constraint(equalTo: parentView.centerXAnchor).isActive = true
    messageImageView.centerYAnchor.constraint(equalTo: parentView.centerYAnchor, constant: -20).isActive = true
    messageImageView.widthAnchor.constraint(equalToConstant: 130).isActive = true
    messageImageView.heightAnchor.constraint(equalToConstant: 130).isActive = true
    
    messageLabel.topAnchor.constraint(equalTo: messageImageView.bottomAnchor, constant: 20).isActive = true
    messageLabel.centerXAnchor.constraint(equalTo: parentView.centerXAnchor).isActive = true
    messageLabel.leftAnchor.constraint(equalTo: parentView.leftAnchor, constant: 20).isActive = true
    messageLabel.rightAnchor.constraint(equalTo: parentView.rightAnchor, constant: -20).isActive = true
    
    messageImageView.image = image
    messageLabel.text = message
    messageLabel.numberOfLines = 0
    messageLabel.textAlignment = .center
    
    self.backgroundView = parentView
    self.separatorStyle = .none
  }
  
  func restore(separator: UITableViewCell.SeparatorStyle = .none) {
    self.backgroundView = nil
    self.separatorStyle = separator
  }
  
}
