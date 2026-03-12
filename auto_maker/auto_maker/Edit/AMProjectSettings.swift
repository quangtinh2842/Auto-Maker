//
//  ProjectSettings.swift
//  auto_maker
//
//  Created by Ngo Quang Tinh on 8/5/24.
//

import AVFoundation

class AMProjectSettings: NSObject, Mappable {
  private var _canvasDimensions: QTSize?
  private var _color: QTColor?
  private var _fps: Int?
  
  required init?(map: Map) {}
  
  func mapping(map: Map) {
    _canvasDimensions <- map["canvasDimensions"]
    _color <- map["color"]
    _fps <- map["fps"]
  }
  
  func canvasDimensions() -> CGSize? {
    _canvasDimensions?.cgSize()
  }
  
  func color() -> QTColor? {
    _color
  }
  
  func fps() -> Int? {
    _fps
  }
  
  func frameDuration() -> CMTime? {
    if _fps != nil {
      return CMTimeMake(value: 1, timescale: Int32(_fps!))
    } else {
      return nil
    }
  }
}
