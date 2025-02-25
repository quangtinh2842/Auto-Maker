//
//  ExportSetting.swift
//  auto_maker
//
//  Created by Ngo Quang Tinh on 8/4/24.
//

import AVFoundation

class AMExportSettings: NSObject, Mappable {
  private var _saveLocation: String?
  private var _fileName: String?
  private var _fileFormat: String?
  
  required init?(map: Map) {}
  
  func mapping(map: Map) {
    _saveLocation <- map["saveLocation"]
    _fileName <- map["fileName"]
    _fileFormat <- map["fileFormat"]
  }
  
  func filePath() -> URL? {
    guard let saveLocation = _saveLocation else { return nil }
    guard let fileName = _fileName else { return nil }
    guard let fileFormat = _fileFormat else { return nil }
    
    if saveLocation.last == "/" {
      return URL(fileURLWithPath: saveLocation+fileName+fileFormat)
    } else {
      return URL(fileURLWithPath: saveLocation+"/"+fileName+fileFormat)
    }
  }
  
  func outputFileType() -> AVFileType? {
    if _fileFormat == ".mp4" {
      return AVFileType.mp4
    } else {
      return nil
    }
  }
}
