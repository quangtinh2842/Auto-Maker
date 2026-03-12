//
//  QTGreenscreening.swift
//  auto_maker
//
//  Created by Ngo Quang Tinh on 7/7/24.
//

import Foundation

class QTGreenscreeningEffect: NSObject, Mappable {
  private var _screenThreshold: Double = 0
  private var _screenColor: String = "green"
  
  required init?(map: Map) {
    let attrs: [String] = []
    let validations = attrs.map {
      map[$0].currentValue != nil
    }.reduce(true) { $0 && $1 }
    if !validations { return nil }
  }
  
  func mapping(map: Map) {
    _screenThreshold <- map["screenThreshold"]
    _screenColor <- map["screenColor"]
  }
  
  override var description: String {
    return self.toJSONString(prettyPrint: true) ?? "nil"
  }
  
  func screenThreshold() -> CGFloat {
    return CGFloat(_screenThreshold)
  }
  
  func screenColor() -> String {
    return _screenColor
  }
}
