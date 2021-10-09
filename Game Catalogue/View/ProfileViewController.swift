//
//  ProfileViewController.swift
//  Game Catalogue
//
//  Created by Budi Darmawan on 02/10/21.
//

import UIKit

class ProfileViewController: UIViewController {
  
  @IBOutlet weak var imgProfile: UIImageView!
  @IBOutlet weak var tvName: UILabel!
  @IBOutlet weak var cardInfo: UIView!
  @IBOutlet weak var tvNumberPhone: UILabel!
  @IBOutlet weak var tvMail: UILabel!
  private lazy var myProfile: Profile = {
    Profile.synchronize()
    return Profile.objProfile
  }()
  
  override func viewWillAppear(_ animated: Bool) {
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationItem.largeTitleDisplayMode = .always
    tabBarController?.tabBar.isHidden = false
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit",
                                                             style: .plain,
                                                             target: self,
                                                             action: #selector(navigateToEditProfile))
    
    self.tvName.text = myProfile.name
    self.tvNumberPhone.text = myProfile.numberPhone
    self.tvMail.text = myProfile.email
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    imgProfile.makeRounded()
    imgProfile.image = UIImage(named: "img_profile")
    cardInfo.backgroundColor = .white
    cardInfo.cornerRadius(15)
    cardInfo.makeShadow()
    
  }
  
  @objc
  private func navigateToEditProfile() {
    let editVC = EditProfileViewController(nibName: "EditProfileViewController", bundle: nil)
    self.navigationController?.pushViewController(editVC, animated: true)
  }
  
}
