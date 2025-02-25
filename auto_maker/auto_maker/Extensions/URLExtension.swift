//
//  URLExtension.swift
//  auto_maker
//
//  Created by Quang Tinh Ngo on 3/20/24.
//

import Foundation

extension URL {
  func unique() -> URL {
    let originalURL = URL(fileURLWithPath: self.path)
    let folderPath = originalURL.deletingLastPathComponent().path
    let pathExtension = originalURL.pathExtension
    let originFileName = originalURL.deletingPathExtension().lastPathComponent
    
    var count = -1
    var filePath: String = ""
    repeat {
      count += 1
      var fileName = ""
      if count == 0 {
        fileName = originFileName
      } else {
        fileName = originFileName + "_\(count)"
      }
      filePath = folderPath + "/\(fileName)" + ".\(pathExtension)"
    } while FileManager.default.fileExists(atPath: filePath)
    
    return URL(fileURLWithPath: filePath)
  }
}
