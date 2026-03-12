//
//  AdvancedSettings.swift
//  auto_maker
//
//  Created by Ngo Quang Tinh on 8/5/24.
//

import Foundation

class AMAdvancedSettings: NSObject, Mappable {
  private var _preset: String?
  
  required init?(map: Map) {}
  
  func mapping(map: Map) {
    _preset <- map["preset"]
  }
  
  func preset() -> String? {
    _preset
  }
}
