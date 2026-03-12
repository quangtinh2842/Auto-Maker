//
//  CommonTypes.swift
//  auto_maker
//
//  Created by Ngo Quang Tinh on 1/13/24.
//

import AVFoundation
import Cocoa

let kTimeScale: CMTimeScale = 10000
let preferredTrackID = kCMPersistentTrackID_Invalid

func json(at filePath: String) throws -> [String: Any]? {
  let toDoScriptsText = try readTextFile(at: filePath)
  if let dataFromString = toDoScriptsText.data(using: .utf8, allowLossyConversion: false) {
    let json = try JSON(data: dataFromString)
    return json.dictionaryObject
  } else {
    return nil
  }
}

func readTextFile(at filePath: String) throws -> String {
  let fileContent = try String(contentsOfFile: filePath, encoding: .utf8)
  return fileContent
}

func error(description: String) -> NSError {
  let domain = "ERROR"
  let code = -9
  let userInfo = [NSLocalizedDescriptionKey: description]
  return NSError(domain: domain, code: code, userInfo: userInfo)
}

func mapValue(_ value: CGFloat, fromRange: (CGFloat, CGFloat), toRange: (CGFloat, CGFloat)) -> CGFloat {
  if value < fromRange.0 {
    return toRange.0
  } else if value > fromRange.1 {
    return toRange.1
  } else {
    return (value - fromRange.0) * (toRange.1 - toRange.0) / (fromRange.1 - fromRange.0) + toRange.0
  }
}

func degreesToRadians(_ degrees: CGFloat) -> CGFloat {
  let radians = degrees/360*(.pi*2)
  return radians
}

func chromaKeyFilterParams(fromHue: CGFloat, toHue: CGFloat) -> [String: Any] {
  let size = 64
  var cubeRGB = [Float]()
  
  for z in 0 ..< size {
    let blue = CGFloat(z) / CGFloat(size-1)
    for y in 0 ..< size {
      let green = CGFloat(y) / CGFloat(size-1)
      for x in 0 ..< size {
        let red = CGFloat(x) / CGFloat(size-1)
        
        let hue = getHue(red: red, green: green, blue: blue)
        var alpha: CGFloat!
        if fromHue > toHue {
          alpha = (hue >= fromHue || hue <= toHue) ? 0 : 1
        } else {
          alpha = (hue >= fromHue && hue <= toHue) ? 0 : 1
        }
        
        cubeRGB.append(Float(red * alpha))
        cubeRGB.append(Float(green * alpha))
        cubeRGB.append(Float(blue * alpha))
        cubeRGB.append(Float(alpha))
      }
    }
  }
  
  let data = Data(bytes: cubeRGB, count: cubeRGB.count * 4)
  
  let parameters: [String: Any] = [
    "inputCubeDimension": size,
    "inputCubeData": data
  ]
  
  return parameters
}

func getHue(red: CGFloat, green: CGFloat, blue: CGFloat) -> CGFloat{
  let color = NSColor(red: red, green: green, blue: blue, alpha: 1)
  var hue: CGFloat = 0
  color.getHue(&hue, saturation: nil, brightness: nil, alpha: nil)
  return hue
}

func getValue(from layer: CALayer, filterName: String, parameterKey: String) -> Any? {
  guard let filters = layer.filters else { return nil }
  for filter in filters {
    if let ciFilter = filter as? CIFilter, ciFilter.name == filterName {
      return ciFilter.value(forKey: parameterKey)
    }
  }
  return nil
}

func updateFilter(layer: CALayer, filterName: String, newParameters: [String: Any]) {
  var filters = layer.filters ?? []
  var updated = false
  
  for (index, filter) in filters.enumerated() {
    if let ciFilter = filter as? CIFilter, ciFilter.name == filterName {
      for (key, value) in newParameters {
        ciFilter.setValue(value, forKey: key)
      }
      filters[index] = ciFilter
      updated = true
      break
    }
  }
  
  if !updated {
    let parameters = newParameters
    let filter = CIFilter(name: filterName, parameters: parameters)
    filters.append(filter!)
  }
  
  layer.filters = filters
}

enum ModelValidationError: Error {
  case Valid
  case InvalidId
  case InvalidTimestamp
  case InvalidBlankAttribute
}
