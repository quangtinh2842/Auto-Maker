//
//  QTColorAdjuster.swift
//  auto_maker
//
//  Created by Ngo Quang Tinh on 7/2/24.
//

import Cocoa

class QTColorAdjuster: NSObject, Mappable {
  private var _exposure: Double = 0
  private var _contrast: Double = 1.0
  private var _saturation: Double = 1.0
  private var _temperature: Double = 0
  private var _transparency: Double = 0
  private var _isNegative: Bool = false
  
  required init?(map: Map) {
    let attrs: [String] = []
    let validations = attrs.map {
      map[$0].currentValue != nil
    }.reduce(true) { $0 && $1 }
    if !validations { return nil }
  }
  
  func mapping(map: Map) {
    _exposure <- map["exposure"]
    _contrast <- map["contrast"]
    _saturation <- map["saturation"]
    _temperature <- map["temperature"]
    _transparency <- map["transparency"]
    _isNegative <- map["isNegative"]
  }
  
  override var description: String {
    return self.toJSONString(prettyPrint: true) ?? "nil"
  }
  
  func exposure() -> Double {
    return _exposure
  }
  
  func contrast() -> Double {
    return _contrast
  }
  
  func saturation() -> Double {
    return _saturation
  }
  
  func temperature() -> CGFloat {
    return CGFloat(_temperature)
  }
  
  func transparency() -> Float {
    return Float(_transparency)
  }
  
  func isNegative() -> Bool {
    return _isNegative
  }
}
