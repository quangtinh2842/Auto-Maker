//
//  QTRotationEffect.swift
//  auto_maker
//
//  Created by Ngo Quang Tinh on 7/11/24.
//

import Foundation

class QTRotationEffect: NSObject, Mappable {
  private var _speed: Double = 0
  private var _isReverse: Bool = false
  
  required init?(map: Map) {
    let attrs: [String] = []
    let validations = attrs.map {
      map[$0].currentValue != nil
    }.reduce(true) { $0 && $1 }
    if !validations { return nil }
  }
  
  func mapping(map: Map) {
    _speed <- map["speed"]
    _isReverse <- map["isReverse"]
  }
  
  override var description: String {
    return self.toJSONString(prettyPrint: true) ?? "nil"
  }
  
  func speed() -> CGFloat {
    return CGFloat(_speed)
  }
  
  func isReverse() -> Bool {
    return _isReverse
  }
}
