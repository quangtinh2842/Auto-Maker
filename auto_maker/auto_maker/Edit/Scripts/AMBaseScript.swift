//
//  BaseScript.swift
//  auto_maker
//
//  Created by Ngo Quang Tinh on 1/24/24.
//

import AVFoundation

class AMBaseScript: NSObject, Mappable {
  class func mapObject(jsonObject: NSDictionary) -> AMBaseScript? {
    fatalError("This method must be overridden")
  }
  
  override init() {}
  
  required init?(map: Map) {}
  
  func mapping(map: Map) {
    fatalError("This method must be overridden")
  }
  
  func validate() -> (ModelValidationError, String?) {
    fatalError("This method must be overridden")
  }
  
  func layer() -> Int {
    fatalError("This method must be overridden")
  }
  
  func startTime() -> CMTime {
    fatalError("This method must be overridden")
  }
  
  func endTime() -> CMTime {
    fatalError("This method must be overridden")
  }
  
  func timeRange() -> CMTimeRange {
    fatalError("This method must be overridden")
  }
}
