//
//  Bright.swift
//  auto_maker
//
//  Created by Ngô Quang Tịnh on 6/26/24.
//

import AVFoundation

class QTBright: NSObject, Mappable {
  private var _brightIn: Double!
  private var _brightOut: Double!
  
  private init(brightIn: Double, brightOut: Double) {
    self._brightIn = brightIn
    self._brightOut = brightOut
  }
  
  required init?(map: Map) {
    let attrs: [String] = ["brightIn", "brightOut"]
    let validations = attrs.map {
      map[$0].currentValue != nil
    }.reduce(true) { $0 && $1 }
    if !validations { return nil }
  }
  
  func mapping(map: Map) {
    _brightIn <- map["brightIn"]
    _brightOut <- map["brightOut"]
  }
  
  override var description: String {
    return self.toJSONString(prettyPrint: true) ?? "nil"
  }
  
  static func least() -> QTBright {
    let brightIn = 1/Double(kTimeScale)
    let brightOut = 1/Double(kTimeScale)
    return QTBright(brightIn: brightIn, brightOut: brightOut)
  }
  
  func brightIn() -> Double {
    return _brightIn
  }
  
  func brightOut() -> Double {
    return _brightOut
  }
}
