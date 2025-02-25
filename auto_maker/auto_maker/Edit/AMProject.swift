//
//  EditProject.swift
//  auto_maker
//
//  Created by Ngo Quang Tinh on 8/6/24.
//

import Foundation

class AMProject: NSObject, Mappable {
  var projectSett: AMProjectSettings?
  var exportSett: AMExportSettings?
  var advancedSett: AMAdvancedSettings?
  var timeLine: AMTimeLine?
  
  required init?(map: Map) {
    let attrs = ["projectSettings", "exportSettings", "advancedSettings", "timeLine"]
    let validations = attrs.map {
      map[$0].currentValue != nil
    }.reduce(true) { $0 && $1 }
    if !validations { return nil }
  }
  
  func mapping(map: Map) {
    projectSett <- map["projectSettings"]
    exportSett <- map["exportSettings"]
    advancedSett <- map["advancedSettings"]
    timeLine <- map["timeLine"]
  }
  
  override var description: String {
    toJSONString(prettyPrint: true)?
      .replacingOccurrences(of: "\\/", with: "/", options: .literal) ?? "nil"
  }
  
  static func amProject(fromFilePath filePath: URL) throws -> AMProject? {
    let string = try String(contentsOf: filePath)
    return AMProject(JSONString: string)
  }
}
