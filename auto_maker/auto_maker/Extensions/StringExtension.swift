//
//  StringExtension.swift
//  auto_maker
//
//  Created by Ngo Quang Tinh on 1/11/24.
//

import Cocoa

extension String {
  func heightWith(constrainedWidth: CGFloat, font: NSFont, fontSize: CGFloat) -> CGFloat {
    if self.isEmpty { return 0 }
    
    var words = self.words()
    var nLines = 0
    var tmp = [String]()
    
    while !words.isEmpty {
      tmp.append(words.first!)
      words.removeFirst()
      
      let lineStr = tmp.joined(separator: " ")
      let width = lineStr.preferredFrameSize(font: font, fontSize: fontSize).width
      
      if width > constrainedWidth {
        if tmp.count != 1 {
          words.insert(tmp.last!, at: 0)
        }
        tmp.removeAll()
        nLines += 1
      } else if words.isEmpty {
        nLines += 1
      }
    }
    
    let char = String(self.first!)
    let heightPerLine = char.preferredFrameSize(font: font, fontSize: fontSize).height
    return CGFloat(nLines)*heightPerLine
  }
  
  func preferredFrameSize(font: NSFont, fontSize: CGFloat) -> CGSize {
    let textLayer = CATextLayer()
    textLayer.string = self
    textLayer.font = font
    textLayer.fontSize = fontSize
    textLayer.setNeedsDisplay()
    textLayer.displayIfNeeded()
    return textLayer.preferredFrameSize()
  }
  
  func words() -> [String] {
    let words = self.components(separatedBy: .whitespacesAndNewlines)
    let filteredWords = words.filter { !$0.isEmpty }
    return filteredWords
  }
}
