//
//  QTVHSEffect.swift
//  auto_maker
//
//  Created by Ngo Quang Tinh on 7/11/24.
//

import Foundation

class QTVHSEffect: NSObject, Mappable {
  private var _grain: Double = 0
  private var _intensity: Double = 0
  
  required init?(map: Map) {
    let attrs: [String] = []
    let validations = attrs.map {
      map[$0].currentValue != nil
    }.reduce(true) { $0 && $1 }
    if !validations { return nil }
  }
  
  func mapping(map: Map) {
    _grain <- map["grain"]
    _intensity <- map["intensity"]
  }
  
  override var description: String {
    return self.toJSONString(prettyPrint: true) ?? "nil"
  }
  
  func grain() -> CGFloat {
    return CGFloat(_grain)
  }
  
  func intensity() -> CGFloat {
    return CGFloat(_intensity)
  }
}
