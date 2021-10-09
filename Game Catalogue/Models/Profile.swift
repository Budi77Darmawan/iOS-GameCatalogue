//
//  Profile.swift
//  Game Catalogue
//
//  Created by Budi Darmawan on 03/10/21.
//

import Foundation

struct Profile {
  let name: String
  let numberPhone: String
  let email: String
  
  static let nameKey = "name_key"
  static let numberPhoneKey = "number_phone_key"
  static let emailKey = "email_key"
  
  static var objProfile: Profile {
    get {
      let profile = Profile(
        name: name,
        numberPhone: numberPhone,
        email: email
      )
      return profile
    }
    set {
      self.name = newValue.name
      self.numberPhone = newValue.numberPhone
      self.email = newValue.email
    }
  }
  
  static private var name: String {
    get {
      return UserDefaults.standard.string(forKey: nameKey) ?? ""
    }
    set {
      UserDefaults.standard.set(newValue, forKey: nameKey)
    }
  }

  static private var numberPhone: String {
    get {
      return UserDefaults.standard.string(forKey: numberPhoneKey) ?? ""
    }
    set {
      UserDefaults.standard.set(newValue, forKey: numberPhoneKey)
    }
  }

  static private var email: String {
    get {
      return UserDefaults.standard.string(forKey: emailKey) ?? ""
    }
    set {
      UserDefaults.standard.set(newValue, forKey: emailKey)
    }
  }
  
  static func synchronize() {
    UserDefaults.standard.synchronize()
  }
}
