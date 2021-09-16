//
//  Resource.swift
//  Game Catalogue
//
//  Created by Budi Darmawan on 26/08/21.
//

import Foundation

enum Resource<T> {
  case loading
  case error(
        _ message: String? = "Internal Server Error",
        _ data: T? = nil
       )
  case success(_ data: T? = nil)
}
