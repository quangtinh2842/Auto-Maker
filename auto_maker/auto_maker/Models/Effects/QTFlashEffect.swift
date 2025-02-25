//
//  QTFlash.swift
//  auto_maker
//
//  Created by Ngo Quang Tinh on 7/5/24.
//

import Foundation

class QTFlashEffect: NSObject, Mappable {
  private var _speed: Double = 0
  private var _isFade: Bool = false
  
  required init?(map: Map) {
    let attrs: [String] = []
    let validations = attrs.map {
      map[$0].currentValue != nil
    }.reduce(true) { $0 && $1 }
    if !validations { return nil }
  }
  
  func mapping(map: Map) {
    _speed <- map["speed"]
    _isFade <- map["isFade"]
  }
  
  override var description: String {
    return self.toJSONString(prettyPrint: true) ?? "nil"
  }
  
  func speed() -> Double {
    return _speed
  }
  
  func isFade() -> Bool {
    return _isFade
  }
}
