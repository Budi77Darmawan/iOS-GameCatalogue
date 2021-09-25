//
//  Debouncer.swift
//  Game Catalogue
//
//  Created by Budi Darmawan on 18/09/21.
//

import Foundation

public class Debouncer: NSObject {
  public var callback: (() -> Void)
  public var delay: Double
  public var timer: Timer?
  
  public init(delay: Double, callback: @escaping (() -> Void)) {
    self.delay = delay
    self.callback = callback
  }
  
  public func call() {
    timer?.invalidate()
    let nextTimer = Timer.scheduledTimer(timeInterval: delay, target: self, selector: #selector(Debouncer.fireNow), userInfo: nil, repeats: false)
    timer = nextTimer
  }
  
  @objc func fireNow() {
    self.callback()
  }
  
  public func cancel() {
    timer?.invalidate()
  }
}
