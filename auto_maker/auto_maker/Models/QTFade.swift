//
//  Fade.swift
//  auto_maker
//
//  Created by Quang Tinh Ngo on 6/18/24.
//

import AVFoundation

class QTFade: NSObject, Mappable {
  private var _fadeIn: Double!
  private var _fadeOut: Double!
  
  private init(fadeIn: Double, fadeOut: Double) {
    self._fadeIn = fadeIn
    self._fadeOut = fadeOut
  }
  
  required init?(map: Map) {
    let attrs: [String] = ["fadeIn", "fadeOut"]
    let validations = attrs.map {
      map[$0].currentValue != nil
    }.reduce(true) { $0 && $1 }
    if !validations { return nil }
  }
  
  func mapping(map: Map) {
    _fadeIn <- map["fadeIn"]
    _fadeOut <- map["fadeOut"]
  }
  
  override var description: String {
    return self.toJSONString(prettyPrint: true) ?? "nil"
  }
  
  static func least() -> QTFade {
    let fadeIn = 1/Double(kTimeScale)
    let fadeOut = 1/Double(kTimeScale)
    return QTFade(fadeIn: fadeIn, fadeOut: fadeOut)
  }
  
  func fadeIn() -> Double {
    return _fadeIn
  }
  
  func fadeOut() -> Double {
    return _fadeOut
  }
}
