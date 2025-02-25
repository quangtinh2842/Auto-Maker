//
//  QTColor.swift
//  auto_maker
//
//  Created by Ngo Quang Tinh on 2/28/24.
//

import Cocoa

class QTColor: NSObject, Mappable {
  private var red: Int = .zero
  private var green: Int = .zero
  private var blue: Int = .zero
  private var alpha: Double = 1
  
  init(red: Int, green: Int, blue: Int, alpha: Double) {
    self.red = red
    self.green = green
    self.blue = blue
    self.alpha = alpha
  }
  
  required init?(map: Map) {
    let attrs = ["red", "green", "blue", "alpha"]
    let validations = attrs.map {
      map[$0].currentValue != nil
    }.reduce(true) { $0 && $1 }
    if !validations { return nil }
  }
  
  func mapping(map: Map) {
    red <- map["red"]
    green <- map["green"]
    blue <- map["blue"]
    alpha <- map["alpha"]
  }
  
  override var description: String {
    return self.toJSONString(prettyPrint: true) ?? "nil"
  }
  
  static func black() -> QTColor {
    return QTColor(red: 0, green: 0, blue: 0, alpha: 1)
  }
  
  static func white() -> QTColor {
    return QTColor(red: 255, green: 255, blue: 255, alpha: 1)
  }
  
  static func clear() -> QTColor {
    return QTColor(red: 0, green: 0, blue: 0, alpha: 0)
  }
  
  func nsColor() -> NSColor {
    let red = CGFloat(self.red)/255
    let green = CGFloat(self.green)/255
    let blue = CGFloat(self.blue)/255
    let alpha = CGFloat(self.alpha)
    return NSColor(red: red, green: green, blue: blue, alpha: alpha)
  }
  
  func cgColor() -> CGColor {
    return nsColor().cgColor
  }
}
