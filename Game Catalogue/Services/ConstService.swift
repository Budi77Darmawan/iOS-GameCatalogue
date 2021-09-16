//
//  ConstService.swift
//  Game Catalogue
//
//  Created by Budi Darmawan on 11/07/21.
//

import Foundation
import Alamofire

struct ConstService {
  
  static let BaseAPI = "https://api.rawg.io/api/"
  static let KeyAPI = "0b2afc2d1bdd44fbbc39c5f08014959c"
//  static let KeyAPI = "INPUT YOUR API KEY"
  
  
  struct rawgType {
    static let games = "games"
    static let detailGameById = games + "/{id}"
  }
}
