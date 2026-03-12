//
//  EditorStorage.swift
//  auto_maker
//
//  Created by Quang Tinh Ngo on 3/9/24.
//

import AVFoundation

class AMTimeLine: NSObject, Mappable {
  private var _sounds: [AMSoundScript]?
  private var _texts: [AMTextScript]?
  private var _images: [AMImageScript]?
  private var _videos: [AMVideoScript]?
  
  required init?(map: Map) {}
  
  func mapping(map: Map) {
    _sounds <- map["sounds"]
    _texts <- map["texts"]
    _images <- map["images"]
    _videos <- map["videos"]
  }
  
  override var description: String {
    if let string = self.toJSONString(prettyPrint: true) {
      return string.replacingOccurrences(of: "\\/", with: "/", options: .literal, range: nil)
    } else {
      return "nil"
    }
  }
  
  func videos() -> [AMVideoScript] {
    return _videos ?? []
  }
  
  func sounds() -> [AMSoundScript] {
    return _sounds ?? []
  }
  
  func endTime() -> CMTime {
    var all = [AMBaseScript]()
    all.append(contentsOf: sounds())
    all.append(contentsOf: videos())
    all.append(contentsOf: imagesAndTexts())
    var maxEndTime: CMTime = .zero
    for script in all {
      maxEndTime = maxEndTime > script.endTime() ? maxEndTime: script.endTime()
    }
    return maxEndTime
  }
  
  func imagesAndTexts() -> [AMBaseScript] {
    var rst = [AMBaseScript]()
    rst.append(contentsOf: _texts ?? [])
    rst.append(contentsOf: _images ?? [])
    return rst
  }
}
