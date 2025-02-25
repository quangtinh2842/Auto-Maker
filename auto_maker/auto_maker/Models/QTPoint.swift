//
//  QTPoint.swift
//  auto_maker
//
//  Created by Ngo Quang Tinh on 2/26/24.
//

import Foundation

class QTPoint: NSObject, Mappable {
  private var _x: Double = .zero
  private var _y: Double = .zero
  
  private override init() {
    _x = .zero
    _y = .zero
  }
  
  required init?(map: Map) {
    let attributes = ["x", "y"]
    let validations = attributes.map {
      map[$0].currentValue != nil
    }.reduce(true) { $0 && $1 }
    if !validations { return nil }
  }
  
  func mapping(map: Map) {
    _x <- map["x"]
    _y <- map["y"]
  }
  
  override var description: String {
    return self.toJSONString(prettyPrint: true) ?? "nil"
  }
  
  static func zero() -> QTPoint {
    return QTPoint()
  }
  
  func cgPoint() -> CGPoint {
    return CGPoint(x: _x, y: _y)
  }
}
