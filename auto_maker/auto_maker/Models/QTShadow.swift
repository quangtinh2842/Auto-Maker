//
//  Shadow.swift
//  auto_maker
//
//  Created by Ngô Quang Tịnh on 6/25/24.
//

import Cocoa

class QTShadow: NSObject, Mappable {
  private var _color: QTColor = .black()
  private var _offset: QTSize = .zero()
  private var _opacity: Double = 1.0
  private var _radius: Double = .zero
  
  required init?(map: Map) {
    let attrs: [String] = []
    let validations = attrs.map {
      map[$0].currentValue != nil
    }.reduce(true) { $0 && $1 }
    if !validations { return nil }
  }
  
  func mapping(map: Map) {
    _color <- map["color"]
    _offset <- map["offset"]
    _opacity <- map["opacity"]
    _radius <- map["radius"]
  }
  
  override var description: String {
    return self.toJSONString(prettyPrint: true) ?? "nil"
  }
  
  func color() -> NSColor {
    return _color.nsColor()
  }
  
  func offset() -> CGSize {
    return _offset.cgSize()
  }
  
  func opacity() -> Float {
    return Float(_opacity)
  }
  
  func radius() -> CGFloat {
    return CGFloat(_radius)
  }
}
