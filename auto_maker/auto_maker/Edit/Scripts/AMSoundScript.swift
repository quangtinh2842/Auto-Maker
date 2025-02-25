//
//  SoundScript.swift
//  auto_maker
//
//  Created by Ngo Quang Tinh on 1/27/24.
//

import AVFoundation

class AMSoundScript: AMBaseScript {
  private var _layer: Int?
  private var _url: URL!
  private var _startTime: Double!
  private var _trim: QTTimeRange?
  private var _volume: Double = 1.0
  private var _fade: QTFade? = nil
  
  required init?(map: Map) {
    super.init(map: map)
    let attrs = ["url", "startTime"]
    let validations = attrs.map {
      map[$0].currentValue != nil
    }.reduce(true) { $0 && $1 }
    if !validations { return nil }
  }
  
  override func mapping(map: Map) {
    _layer <- map["layer"]
    _url <- (map["url"], URLTransform())
    _startTime <- map["startTime"]
    _trim <- map["trim"]
    _volume <- map["volume"]
    _fade <- map["fade"]
  }
  
  override class func mapObject(jsonObject: NSDictionary) -> AMBaseScript? {
    return Mapper<AMSoundScript>().map(JSONObject: jsonObject)
  }
  
  override var description: String {
    return self.toJSONString() ?? "nil"
  }
  
  override func validate() -> (ModelValidationError, String?) {
    if _layer == nil {
      return (.InvalidBlankAttribute, "layer")
    }
    
    if _url == nil || _url.absoluteString.isEmpty {
      return (.InvalidBlankAttribute, "url")
    }
    
    if _startTime == nil {
      return (.InvalidBlankAttribute, "startTime")
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
  
  func asset() -> AVAsset {
    if _url.absoluteString.contains("http") {
      return AVAsset(url: _url)
    } else {
      return AVAsset(url: URL(fileURLWithPath: _url.path))
    }
  }
}

extension AMSoundScript {
  func trim() -> CMTimeRange {
    return _trim?.cmTimeRange() ?? CMTimeRange(start: .zero, duration: asset().duration)
  }
  
  func volume() -> Float {
    return Float(_volume)
  }
  
  func fade() -> QTFade? {
    return _fade
  }
}
