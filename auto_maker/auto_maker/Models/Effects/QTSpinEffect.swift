//
//  QTSpinEffect.swift
//  auto_maker
//
//  Created by Ngo Quang Tinh on 7/10/24.
//

import Foundation

class QTSpinEffect: NSObject, Mappable {
  private var _isBounce: Bool = false
  private var _isLoop: Bool = false
  private var _isReverse: Bool = false
  
  required init?(map: Map) {
    let attrs: [String] = []
    let validations = attrs.map {
      map[$0].currentValue != nil
    }.reduce(true) { $0 && $1 }
    if !validations { return nil }
  }
  
  func mapping(map: Map) {
    _isBounce <- map["isBounce"]
    _isLoop <- map["isLoop"]
    _isReverse <- map["isReverse"]
  }
  
  override var description: String {
    return self.toJSONString(prettyPrint: true) ?? "nil"
  }
  
  func isBounce() -> Bool {
    return _isBounce
  }
  
  func isLoop() -> Bool {
    return _isLoop
  }
  
  func isReverse() -> Bool {
    return _isReverse
  }
}
