//
//  ConvertDate.swift
//  Game Catalogue
//
//  Created by Budi Darmawan on 27/08/21.
//

import Foundation

class ConvertDate {
  static func formatDate(date: String, fromDateFormat: String = "yyyy-mm-dd", resultFormat: String = "DD MMM YYYY") -> String {
    let fromFormatter = DateFormatter()
    fromFormatter.dateFormat = fromDateFormat
    
    let resultFormatter = DateFormatter()
    resultFormatter.dateFormat = resultFormat
    
    let newDate = fromFormatter.date(from: date)
    
    guard newDate != nil else {
      return date
    }
    
    return resultFormatter.string(from: newDate!)
  }
}
