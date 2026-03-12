//
//  QTFont.swift
//  auto_maker
//
//  Created by Quang Tinh Ngo on 6/5/24.
//

import Cocoa

class QTFont: NSObject, Mappable {
  private var _name: String!
  private var _size: Double!
  
  init(name: String, size: Double) {
    self._name = name
    self._size = size
  }
  
  required init?(map: Map) {
    let attrs = ["name", "size"]
    let validations = attrs.map {
      map[$0].currentValue != nil
    }.reduce(true) { $0 && $1 }
    if !validations { return nil }
  }
  
  func mapping(map: Map) {
    _name <- map["name"]
    _size <- map["size"]
  }
  
  override var description: String {
    return self.toJSONString(prettyPrint: true) ?? "nil"
  }
  
  func nsFont() throws -> NSFont {
    if let font = NSFont(name: _name, size: CGFloat(_size)) {
      return font
    } else {
      throw error(description: "QTFont/nsFont: font is nil")
    }
  }
  
  func size() -> CGFloat {
    return CGFloat(_size)
  }
}

extension QTFont {
  class func robotoMediumFont(ofSize fontSize: Double) -> QTFont {
    return QTFont(name: "Roboto-Medium", size: fontSize)
  }
}
