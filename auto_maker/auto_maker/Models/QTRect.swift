//
//  QTRect.swift
//  auto_maker
//
//  Created by Ngo Quang Tinh on 2/25/24.
//

import Foundation

class QTRect: NSObject, Mappable {
  private var _point: QTPoint = .zero()
  private var _size: QTSize = .zero()
  
  private override init() {
    _point = .zero()
    _size = .zero()
  }
  
  required init?(map: Map) {
    let attributes = ["point", "size"]
    let validations = attributes.map {
      map[$0].currentValue != nil
    }.reduce(true) { $0 && $1 }
    if !validations { return nil }
  }
  
  func mapping(map: Map) {
    _point <- map["point"]
    _size <- map["size"]
  }
  
  override var description: String {
    return self.toJSONString(prettyPrint: true) ?? "nil"
  }
  
  static func zero() -> QTRect {
    return QTRect()
  }
  
  func getPoint() -> QTPoint {
    return _point
  }
  
  func getSize() -> QTSize {
    return _size
  }
  
  func cgRect() -> CGRect {
    return CGRect(origin: _point.cgPoint(), size: _size.cgSize())
  }
}
