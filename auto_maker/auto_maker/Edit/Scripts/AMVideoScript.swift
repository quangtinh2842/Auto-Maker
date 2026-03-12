//
//  AssetScript.swift
//  auto_maker
//
//  Created by Ngo Quang Tinh on 1/24/24.
//

import AVFoundation

class AMVideoScript: AMBaseScript {
  private var _layer: Int?
  private var _startTime: Double!
  private var _trim: QTTimeRange?
  private var _frame: QTRect?
  private var _url: URL!
  private var _crop: QTRect? = nil
  private var _cornerRadius: Double = .zero
  private var _fade: QTFade? = nil
  private var _bright: QTBright? = nil
  private var _shadow: QTShadow? = nil
  private var _rotate: Double = .zero
  private var _colorAdjuster: QTColorAdjuster? = nil
  private var _filters: QTFilters? = nil
  private var _effects: QTEffects? = nil
  
  required init?(map: Map) {
    super.init(map: map)
    let attrs = ["startTime", "url"]
    let validations = attrs.map {
      map[$0].currentValue != nil
    }.reduce(true) { $0 && $1 }
    if !validations { return nil }
  }
  
  override func mapping(map: Map) {
    _layer <- map["layer"]
    _startTime <- map["startTime"]
    _trim <- map["trim"]
    _frame <- map["frame"]
    _url <- (map["url"], URLTransform())
    _crop <- map["crop"]
    _cornerRadius <- map["cornerRadius"]
    _fade <- map["fade"]
    _bright <- map["bright"]
    _shadow <- map["shadow"]
    _rotate <- map["rotate"]
    _colorAdjuster <- map["colorAdjuster"]
    _filters <- map["filters"]
    _effects <- map["effects"]
  }
  
  override class func mapObject(jsonObject: NSDictionary) -> AMBaseScript? {
    return Mapper<AMVideoScript>().map(JSONObject: jsonObject)
  }
  
  override var description: String {
    return self.toJSONString(prettyPrint: true) ?? "nil"
  }
  
  override func validate() -> (ModelValidationError, String?) {
    if _startTime == nil {
      return (.InvalidBlankAttribute, "startTime")
    }
    
    if _frame == nil {
      return (.InvalidBlankAttribute, "frame")
    }
    
    if _url == nil || _url.absoluteString.isEmpty {
      return (.InvalidBlankAttribute, "url")
    }
    
    return (.Valid, nil)
  }
  
  override func layer() -> Int {
    return _layer ?? 0
  }
  
  override func startTime() -> CMTime {
    return CMTime(seconds: _startTime, preferredTimescale: kTimeScale)
  }
  
  override func endTime() -> CMTime {
    let end = _startTime + trim().duration.seconds
    return CMTime(seconds: end, preferredTimescale: kTimeScale)
  }
  
  override func timeRange() -> CMTimeRange {
    return CMTimeRange(start: startTime(), end: endTime())
  }
  
  func trim() -> CMTimeRange {
    return _trim?.cmTimeRange() ?? CMTimeRange(start: .zero, duration: asset().duration)
  }
  
  func frame() throws -> CGRect {
    if _frame == nil {
      return CGRect(origin: .zero, size: try naturalSize())
    } else {
      return _frame!.cgRect()
    }
  }
  
  func naturalSize() throws -> CGSize {
    return try asset().assetTrack(withMediaType: .video).naturalSize
  }
  
  func asset() -> AVAsset {
    if _url.absoluteString.contains("http") {
      return AVAsset(url: _url)
    } else {
      return AVAsset(url: URL(fileURLWithPath: _url.path))
    }
  }
  
  func crop() throws -> CGRect {
    if _crop == nil {
      let track = try asset().assetTrack(withMediaType: .video)
      return CGRect(origin: .zero, size: track.naturalSize)
    } else {
      return _crop!.cgRect()
    }
  }
  
  func cornerRadius() -> CGFloat {
    return CGFloat(_cornerRadius)
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
