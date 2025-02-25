//
//  SubtitleScript.swift
//  auto_maker
//
//  Created by Ngo Quang Tinh on 1/27/24.
//

import Cocoa
import AVFoundation

class AMTextScript: AMBaseScript {
  private var _layer: Int!
  private var _startTime: Double!
  private var _duration: Double!
  private var _frame: QTRect!
  private var _string: String!
  private var _font: QTFont! = .robotoMediumFont(ofSize: 13)
  private var _foregroundColor: QTColor! = .black()
  private var _strokeWidth: Double! = .zero
  private var _strokeColor: QTColor! = .clear()
  private var _backgroundColor: QTColor! = .clear()
  private var _cornerRadius: Double! = .zero
  private var _borderWidth: Double! = .zero
  private var _borderColor: QTColor! = .clear()
  private var _fade: QTFade? = nil
  private var _bright: QTBright? = nil
  private var _shadow: QTShadow? = nil
  private var _rotate: Double = .zero
  private var _colorAdjuster: QTColorAdjuster? = nil
  private var _filters: QTFilters? = nil
  private var _effects: QTEffects? = nil
  
  required init?(map: Map) {
    super.init(map: map)
    let attrs = ["layer", "startTime", "duration", "frame", "string"]
    let validations = attrs.map {
      map[$0].currentValue != nil
    }.reduce(true) { $0 && $1 }
    if !validations { return nil }
  }
  
  override func mapping(map: Map) {
    _layer <- map["layer"]
    _startTime <- map["startTime"]
    _duration <- map["duration"]
    _frame <- map["frame"]
    _string <- map["string"]
    _font <- map["font"]
    _foregroundColor <- map["foregroundColor"]
    _strokeWidth <- map["strokeWidth"]
    _strokeColor <- map["strokeColor"]
    _backgroundColor <- map["backgroundColor"]
    _cornerRadius <- map["cornerRadius"]
    _borderWidth <- map["borderWidth"]
    _borderColor <- map["borderColor"]
    _fade <- map["fade"]
    _bright <- map["bright"]
    _shadow <- map["shadow"]
    _rotate <- map["rotate"]
    _colorAdjuster <- map["colorAdjuster"]
    _filters <- map["filters"]
    _effects <- map["effects"]
  }
  
  override class func mapObject(jsonObject: NSDictionary) -> AMBaseScript? {
    return Mapper<AMTextScript>().map(JSONObject: jsonObject)
  }
  
  override var description: String {
    return self.toJSONString(prettyPrint: true) ?? "nil"
  }
  
  override func validate() -> (ModelValidationError, String?) {
    if _layer == nil {
      return (.InvalidBlankAttribute, "layer")
    }
    
    if _startTime == nil {
      return (.InvalidBlankAttribute, "startTime")
    }
    
    if _duration == nil {
      return (.InvalidBlankAttribute, "duration")
    }
    
    if _frame == nil {
      return (.InvalidBlankAttribute, "frame")
    }
    
    if _string == nil || _string.isEmpty {
      return (.InvalidBlankAttribute, "string")
    }
    
    return (.Valid, nil)
  }
  
  override func layer() -> Int {
    return _layer
  }
  
  override func startTime() -> CMTime {
    return CMTime(seconds: _startTime, preferredTimescale: kTimeScale)
  }
  
  override func endTime() -> CMTime {
    let end = _startTime + _duration
    return CMTime(seconds: end, preferredTimescale: kTimeScale)
  }
  
  override func timeRange() -> CMTimeRange {
    return CMTimeRange(start: startTime(), end: endTime())
  }
  
  func frame() -> CGRect {
    return _frame.cgRect()
  }
  
  func string() -> String {
    return _string
  }
  
  func font() throws -> NSFont {
    return try _font.nsFont()
  }
  
  func fontSize() -> CGFloat {
    return _font.size()
  }
  
  func foregroundColor() -> NSColor {
    return _foregroundColor.nsColor()
  }
  
  func strokeWidth() -> CGFloat {
    return CGFloat(_strokeWidth)
  }
  
  func strokeColor() -> NSColor {
    return _strokeColor.nsColor()
  }
  
  func backgroundColor() -> NSColor {
    return _backgroundColor.nsColor()
  }
  
  func cornerRadius() -> CGFloat {
    return CGFloat(_cornerRadius)
  }
  
  func borderWidth() -> CGFloat {
    return CGFloat(_borderWidth)
  }
  
  func borderColor() -> NSColor {
    return _borderColor.nsColor()
  }
  
  func fade() -> QTFade? {
    return _fade
  }
  
  func bright() -> QTBright? {
    return _bright
  }
  
  func shadow() -> QTShadow? {
    return _shadow
  }
  
  func rotate() -> CGFloat {
    return CGFloat(_rotate)
  }
  
  func colorAdjuster() -> QTColorAdjuster? {
    return _colorAdjuster
  }
  
  func filters() -> QTFilters? {
    return _filters
  }
  
  func effects() -> QTEffects? {
    return _effects
  }
}
