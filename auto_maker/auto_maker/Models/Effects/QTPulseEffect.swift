//
//  QTPulse.swift
//  auto_maker
//
//  Created by Ngo Quang Tinh on 7/7/24.
//

import Foundation

class QTPulseEffect: NSObject, Mappable {
  private var _speed: Double = 0
  private var _amount: Double = 0
  private var _isLoop: Bool = false
  
  required init?(map: Map) {
    let attrs: [String] = []
    let validations = attrs.map {
      map[$0].currentValue != nil
    }.reduce(true) { $0 && $1 }
    if !validations { return nil }
  }
  
  func mapping(map: Map) {
    _speed <- map["speed"]
    _amount <- map["amount"]
    _isLoop <- map["isLoop"]
  }
  
  override var description: String {
    return self.toJSONString(prettyPrint: true) ?? "nil"
  }
  
  func speed() -> CGFloat {
    return CGFloat(_speed)
  }
  
  func amount() -> CGFloat {
    return CGFloat(_amount)
  }
  
  func isLoop() -> Bool {
    return _isLoop
  }
}
