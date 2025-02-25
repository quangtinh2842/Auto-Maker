//
//  QTEffects.swift
//  auto_maker
//
//  Created by Ngo Quang Tinh on 7/5/24.
//

import Cocoa

class QTEffects: NSObject, Mappable {
  private var _flash: QTFlashEffect?
  private var _shake: QTShakeEffect?
  private var _pulse: QTPulseEffect?
  private var _greenscreening: QTGreenscreeningEffect?
  private var _slowZoom: QTSlowZoomEffect?
//  private var _isBlurFill: Bool = false
  private var _spin: QTSpinEffect?
//  private var _vhs: QTVHSEffect?
  private var _rotation: QTRotationEffect?
  private var _blur: QTBlurEffect?
  private var _isDisco: Bool = false
  private var _isColorShift: Bool = false
  
  required init?(map: Map) {
    let attrs: [String] = []
    let validations = attrs.map {
      map[$0].currentValue != nil
    }.reduce(true) { $0 && $1 }
    if !validations { return nil }
  }
  
  func mapping(map: Map) {
    _flash <- map["flash"]
    _shake <- map["shake"]
    _pulse <- map["pulse"]
    _greenscreening <- map["greenscreening"]
    _slowZoom <- map["slowZoom"]
//    _isBlurFill <- map["isBlurFill"]
    _spin <- map["spin"]
//    _vhs <- map["vhs"]
    _rotation <- map["rotation"]
    _blur <- map["blur"]
    _isDisco <- map["isDisco"]
    _isColorShift <- map["isColorShift"]
  }
  
  override var description: String {
    return self.toJSONString(prettyPrint: true) ?? "nil"
  }
  
  func flash() -> QTFlashEffect? {
    return _flash
  }
  
  func shake() -> QTShakeEffect? {
    return _shake
  }
  
  func pulse() -> QTPulseEffect? {
    return _pulse
  }
  
  func greenscreening() -> QTGreenscreeningEffect? {
    return _greenscreening
  }
  
  func slowZoom() -> QTSlowZoomEffect? {
    return _slowZoom
  }
  
//  func isBlurFill() -> Bool {
//    return _isBlurFill
//  }
  
  func spin() -> QTSpinEffect? {
    return _spin
  }
  
//  func vhs() -> QTVHSEffect? {
//    return _vhs
//  }
  
  func rotation() -> QTRotationEffect? {
    return _rotation
  }
  
  func blur() -> QTBlurEffect? {
    return _blur
  }
  
  func isDisco() -> Bool {
    return _isDisco
  }
  
  func isColorShift() -> Bool {
    return _isColorShift
  }
}
