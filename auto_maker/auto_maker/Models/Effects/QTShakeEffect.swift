//
//  QTShakeEffect.swift
//  auto_maker
//
//  Created by Ngo Quang Tinh on 7/6/24.
//

import Foundation

class QTShakeEffect: NSObject, Mappable {
  private var _speed: Double = 0
  
  required init?(map: Map) {
    let attrs: [String] = []
    let validations = attrs.map {
      map[$0].currentValue != nil
    }.reduce(true) { $0 && $1 }
    if !validations { return nil }
  }
  
  func mapping(map: Map) {
    _speed <- map["speed"]
  }
  
  override var description: String {
    return self.toJSONString(prettyPrint: true) ?? "nil"
  }
  
  func speed() -> Double {
    return _speed
  }
}
