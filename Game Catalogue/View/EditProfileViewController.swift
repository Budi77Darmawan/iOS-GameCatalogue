//
//  EditProfileViewController.swift
//  Game Catalogue
//
//  Created by Budi Darmawan on 03/10/21.
//

import UIKit

class EditProfileViewController: UIViewController {
  
  @IBOutlet weak var imgProfile: UIImageView!
  @IBOutlet weak var etName: UITextField!
  @IBOutlet weak var etPhoneNumber: UITextField!
  @IBOutlet weak var etMail: UITextField!
  
  private lazy var myProfile: Profile = {
    Profile.synchronize()
    return Profile.objProfile
  }()
  
  override func viewWillAppear(_ animated: Bool) {
    navigationItem.largeTitleDisplayMode = .never
    tabBarController?.tabBar.isHidden = true
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save",
                                                             style: .plain,
                                                             target: self,
                                                             action: #selector(actionSaveProfile))
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    imgProfile.makeRounded()
    imgProfile.image = UIImage(named: "img_profile")
    etName.text = myProfile.name
    etPhoneNumber.text = myProfile.numberPhone
    etMail.text = myProfile.email
    
  }
  
  @objc
  private func actionSaveProfile() {
    let name = etName.text?.trimmingCharacters(in: .whitespaces) ?? ""
    let phoneNumber = etPhoneNumber.text?.trimmingCharacters(in: .whitespaces) ?? ""
    let mail = etMail.text?.trimmingCharacters(in: .whitespaces) ?? ""
    if name.isEmpty == true || phoneNumber.isEmpty == true || mail.isEmpty == true {
      showAlertError()
    } else {
      let newObjProfile = Profile(name: name, numberPhone: phoneNumber, email: mail)
      Profile.objProfile = newObjProfile
      navigationController?.popViewController(animated: true)
    }
  }
  
  private func showAlertError() {
    let alert = UIAlertController(
      title: "Failed to save",
      message: "Unable to update because there is an empty field",
      preferredStyle: .alert
    )
    
    alert.addAction(UIAlertAction(title: "Got it!", style: .default) { _ in
      alert.dismiss(animated: true, completion: nil)
    })
    
    self.present(alert, animated: true)
  }
  
  
}
