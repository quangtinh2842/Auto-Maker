//
//  CMTimeRangeExtension.swift
//  auto_maker
//
//  Created by Ngo Quang Tinh on 2/23/24.
//

import AVFoundation

class QTTimeRange: NSObject, Mappable {
  private var _start: Double!
  private var _end: Double!
    
  init(start: Double, end: Double) {
    self._start = start
    self._end = end
  }
  
  required init?(map: Map) {
    let attrs = ["start", "end"]
    let validations = attrs.map {
      map[$0].currentValue != nil
    }.reduce(true) { $0 && $1 }
    if !validations { return nil }
  }
  
  func mapping(map: Map) {
    _start <- map["start"]
    _end <- map["end"]
  }
  
  override var description: String {
    return self.toJSONString(prettyPrint: true) ?? "nil"
  }
  
  static func least() -> QTTimeRange {
    return QTTimeRange(start: .zero, end: 1/Double(kTimeScale))
  }
  
  func cmTimeRange() -> CMTimeRange {
    let start = CMTime(seconds: _start, preferredTimescale: kTimeScale)
    let end = CMTime(seconds: _end, preferredTimescale: kTimeScale)
    return CMTimeRange(start: start, end: end)
  }
}
