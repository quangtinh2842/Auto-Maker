//
//  QTFilters.swift
//  auto_maker
//
//  Created by Ngo Quang Tinh on 7/3/24.
//

import Cocoa

class QTFilters: NSObject, Mappable {
  private var _contrast: Double = 0
  private var _whiteOverlay: Double = 0
  private var _blackOverlay: Double = 0
  private var _yellowOverlay: Double = 0
  private var _orangeOverlay: Double = 0
  private var _redOverlay: Double = 0
  private var _pinkOverlay: Double = 0
  private var _purpleOverlay: Double = 0
  private var _blueOverlay: Double = 0
  private var _turquoiseOverlay: Double = 0
  private var _greenOverlay: Double = 0
  private var _blackAndWhite: Double = 0
  
  required init?(map: Map) {
    let attrs: [String] = []
    let validations = attrs.map {
      map[$0].currentValue != nil
    }.reduce(true) { $0 && $1 }
    if !validations { return nil }
  }
  
  func mapping(map: Map) {
    _contrast <- map["contrast"]
    _whiteOverlay <- map["whiteOverlay"]
    _blackOverlay <- map["blackOverlay"]
    _yellowOverlay <- map["yellowOverlay"]
    _orangeOverlay <- map["orangeOverlay"]
    _redOverlay <- map["redOverlay"]
    _pinkOverlay <- map["pinkOverlay"]
    _purpleOverlay <- map["purpleOverlay"]
    _blueOverlay <- map["blueOverlay"]
    _turquoiseOverlay <- map["turquoiseOverlay"]
    _greenOverlay <- map["greenOverlay"]
    _blackAndWhite <- map["blackAndWhite"]
  }
  
  override var description: String {
    return self.toJSONString(prettyPrint: true) ?? "nil"
  }
  
  func contrast() -> CGFloat {
    return CGFloat(_contrast)
  }
  
  func whiteOverlay() -> CGFloat {
    return CGFloat(_whiteOverlay)
  }
  
  func blackOverlay() -> CGFloat {
    return CGFloat(_blackOverlay)
  }
  
  func yellowOverlay() -> CGFloat {
    return CGFloat(_yellowOverlay)
  }
  
  func orangeOverlay() -> CGFloat {
    return CGFloat(_orangeOverlay)
  }
  
  func redOverlay() -> CGFloat {
    return CGFloat(_redOverlay)
  }
  
  func pinkOverlay() -> CGFloat {
    return CGFloat(_pinkOverlay)
  }
  
  func purpleOverlay() -> CGFloat {
    return CGFloat(_purpleOverlay)
  }
  
  func blueOverlay() -> CGFloat {
    return CGFloat(_blueOverlay)
  }
  
  func turquoiseOverlay() -> CGFloat {
    return CGFloat(_turquoiseOverlay)
  }
  
  func greenOverlay() -> CGFloat {
    return CGFloat(_greenOverlay)
  }
  
  func blackAndWhite() -> CGFloat {
    return CGFloat(_blackAndWhite)
  }
}
