//
//  Observable.swift
//  Game Catalogue
//
//  Created by Budi Darmawan on 24/09/21.
//

import Foundation

class Observable<T> {
  
  var value: T? {
    didSet {
      listener?(value)
    }
  }
  
  private var listener: ((T?) -> Void)?
  
  init(_ value: T?) {
    self.value = value
  }
  
  func bind(_ closure: @escaping (T?) -> Void) {
    closure(value)
    listener = closure
  }
}
