//
//  ConvertType.swift
//  Game Catalogue
//
//  Created by Budi Darmawan on 25/09/21.
//

import Foundation

class ConvertType {
  static func listPlatformsToString (list: [Platforms]) -> String {
    var result = ""
    var arrayResult = [String]()
    for item in list {
      arrayResult.append(item.platform.name)
    }
    result = arrayResult.isEmpty ? "-" : arrayResult.joined(separator: ", ")
    return result
  }
  
  static func listGenresToString (list: [Genre]) -> String {
    var result = ""
    var arrayResult = [String]()
    for item in list {
      arrayResult.append(item.name)
    }
    result = arrayResult.isEmpty ? "-" : arrayResult.joined(separator: ", ")
    return result
  }
  
  static func listDevelopersToString (list: [Developers]) -> String {
    var result = ""
    var arrayResult = [String]()
    for item in list {
      arrayResult.append(item.name)
    }
    result = arrayResult.isEmpty ? "-" : arrayResult.joined(separator: ", ")
    return result
  }
  
  static func listPublishersToString (list: [Publisher]) -> String {
    var result = ""
    var arrayResult = [String]()
    for item in list {
      arrayResult.append(item.name)
    }
    result = arrayResult.isEmpty ? "-" : arrayResult.joined(separator: ", ")
    return result
  }
}
