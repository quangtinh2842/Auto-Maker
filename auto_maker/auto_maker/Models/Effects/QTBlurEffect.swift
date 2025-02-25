//
//  QTBlurEffect.swift
//  auto_maker
//
//  Created by Ngo Quang Tinh on 7/11/24.
//

import Foundation

class QTBlurEffect: NSObject, Mappable {
  private var _value: Double = 0
  
  required init?(map: Map) {
    let attrs: [String] = []
    let validations = attrs.map {
      map[$0].currentValue != nil
    }.reduce(true) { $0 && $1 }
    if !validations { return nil }
  }
  
  func mapping(map: Map) {
    _value <- map["value"]
  }
  
  override var description: String {
    return self.toJSONString(prettyPrint: true) ?? "nil"
  }
  
  func value() -> CGFloat {
    return CGFloat(_value)
  }
}
