//
//  ImageScript2.swift
//  auto_maker
//
//  Created by Ngo Quang Tinh on 1/26/24.
//

import AVFoundation
import Cocoa
import SVGKit

class AMImageScript: AMBaseScript {
  private var _layer: Int!
  private var _startTime: Double!
  private var _duration: Double!
  private var _frame: QTRect?
  private var _url: URL!
  private var _crop: QTRect! = nil
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
    let attrs = ["layer", "startTime", "duration", "url"]
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
    _url <- (map["url"], URLTransform())
    _crop <- map["crop"]
    _backgroundColor <- map["backgroundColor"]
    _cornerRadius <- map["cornerRadius"]
    _borderWidth <- map["borderWidth"]
    _borderColor <- map["borderColor"]
    _fade <- map["fade"]
    _shadow <- map["shadow"]
    _bright <- map["bright"]
    _rotate <- map["rotate"]
    _colorAdjuster <- map["colorAdjuster"]
    _filters <- map["filters"]
    _effects <- map["effects"]
  }
  
  override class func mapObject(jsonObject: NSDictionary) -> AMBaseScript? {
    return Mapper<AMImageScript>().map(JSONObject: jsonObject)
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
    
    if _url == nil || _url.absoluteString.isEmpty {
      return (.InvalidBlankAttribute, "url")
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
  
  func frame() throws -> CGRect {
    if _frame == nil {
      let size = try nsImage().size
      return CGRect(origin: .zero, size: size)
    } else {
      return _frame!.cgRect()
    }
  }
  
  func nsImage() throws -> NSImage  {
    let url = _url.absoluteString.contains("http") ? _url : URL(fileURLWithPath: _url.path)
    
    if _url.absoluteString.contains(".svg") {
      if let svgImage = SVGKImage(contentsOf: url) {
        return svgImage.nsImage
      } else {
        throw error(description: "ImageScript/nsImage: svgImage is nil")
      }
    } else {
      if let image = NSImage(contentsOf: url!) {
        return image
      } else {
        throw error(description: "ImageScript/nsImage: image is nil")
      }
    }
  }
  
  func crop() throws -> CGRect {
    if _crop == nil {
      let image = try nsImage()
      return CGRect(origin: .zero, size: image.size)
    } else {
      return _crop.cgRect()
    }
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
