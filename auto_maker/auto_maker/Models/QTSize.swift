//
//  QTSize.swift
//  auto_maker
//
//  Created by Ngo Quang Tinh on 2/25/24.
//

import Foundation

class QTSize: NSObject, Mappable {
  private var _width: Double = .zero
  private var _height: Double = .zero
  
  private override init() {
    _width = .zero
    _height = .zero
  }
  
  required init?(map: Map) {
    let attributes = ["width", "height"]
    let validations = attributes.map {
      map[$0].currentValue != nil
    }.reduce(true) { $0 && $1 }
    if !validations { return nil }
  }
  
  func mapping(map: Map) {
    _width <- map["width"]
    _height <- map["height"]
  }
  
  override var description: String {
    return self.toJSONString(prettyPrint: true) ?? "nil"
  }
  
  static func zero() -> QTSize {
     return QTSize()
  }
  
  func width() -> CGFloat {
    return CGFloat(_width)
  }
  
  func height() -> CGFloat {
    return CGFloat(_height)
  }
  
  func cgSize() -> CGSize {
    return CGSize(width: _width, height: _height)
  }
}
