//
//  Filters.swift
//  auto_maker
//
//  Created by Ngo Quang Tinh on 8/6/24.
//

import Cocoa

extension AMProcessor {
  func addFilters(_ filters: QTFilters, for layer: CALayer) {
    addContrastFilter(for: layer, withIntensity: filters.contrast())
    addWhiteOverlay(for: layer, withIntensity: filters.whiteOverlay())
    addBlackOverlay(for: layer, withIntensity: filters.blackOverlay())
    addYellowOverlay(for: layer, withIntensity: filters.yellowOverlay())
    addOrangeOverlay(for: layer, withIntensity: filters.orangeOverlay())
    addRedOverlay(for: layer, withIntensity: filters.redOverlay())
    addPinkOverlay(for: layer, withIntensity: filters.pinkOverlay())
    addPurpleOverlay(for: layer, withIntensity: filters.purpleOverlay())
    addBlueOverlay(for: layer, withIntensity: filters.blueOverlay())
    addTurquoiseOverlay(for: layer, withIntensity: filters.turquoiseOverlay())
    addGreenOverlay(for: layer, withIntensity: filters.greenOverlay())
    addBlackAndWhiteFilter(for: layer, withIntensity: filters.blackAndWhite())
  }
  
  func addContrastFilter(for layer: CALayer, withIntensity intensity: CGFloat) {
    let contrast = mapValue(intensity, fromRange: (0, 1), toRange: (1, 1.08))
    let filterName = "CIColorControls"
    let parameters = [ "inputContrast": contrast ]
    updateFilter(layer: layer, filterName: filterName, newParameters: parameters)
  }
  
  func addWhiteOverlay(for layer: CALayer, withIntensity intensity: CGFloat) {
    addNewOverlay(withColor: .white, andIntensity: intensity, for: layer)
  }
  
  func addBlackOverlay(for layer: CALayer, withIntensity intensity: CGFloat) {
    addNewOverlay(withColor: .black, andIntensity: intensity, for: layer)
  }
  
  func addYellowOverlay(for layer: CALayer, withIntensity intensity: CGFloat) {
    let color = CGColor(red: 255/255.0, green: 255/255.0, blue: 0/255.0, alpha: 1)
    addNewOverlay(withColor: color, andIntensity: intensity, for: layer)
  }
  
  func addOrangeOverlay(for layer: CALayer, withIntensity intensity: CGFloat) {
    let color = CGColor(red: 255/255.0, green: 165/255.0, blue: 0/255.0, alpha: 1)
    addNewOverlay(withColor: color, andIntensity: intensity, for: layer)
  }
  
  func addRedOverlay(for layer: CALayer, withIntensity intensity: CGFloat) {
    let color = CGColor(red: 255/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1)
    addNewOverlay(withColor: color, andIntensity: intensity, for: layer)
  }

  func addPinkOverlay(for layer: CALayer, withIntensity intensity: CGFloat) {
    let color = CGColor(red: 255/255.0, green: 192/255.0, blue: 203/255.0, alpha: 1)
    addNewOverlay(withColor: color, andIntensity: intensity, for: layer)
  }
  
  func addPurpleOverlay(for layer: CALayer, withIntensity intensity: CGFloat) {
    let color = CGColor(red: 128/255.0, green: 0/255.0, blue: 128/255.0, alpha: 1)
    addNewOverlay(withColor: color, andIntensity: intensity, for: layer)
  }
  
  func addBlueOverlay(for layer: CALayer, withIntensity intensity: CGFloat) {
    let color = CGColor(red: 0/255.0, green: 0/255.0, blue: 255/255.0, alpha: 1)
    addNewOverlay(withColor: color, andIntensity: intensity, for: layer)
  }
  
  func addTurquoiseOverlay(for layer: CALayer, withIntensity intensity: CGFloat) {
    let color = CGColor(red: 64/255.0, green: 224/255.0, blue: 208/255.0, alpha: 1)
    addNewOverlay(withColor: color, andIntensity: intensity, for: layer)
  }
  
  func addGreenOverlay(for layer: CALayer, withIntensity intensity: CGFloat) {
    let color = CGColor(red: 0/255.0, green: 128/255.0, blue: 0/255.0, alpha: 1)
    addNewOverlay(withColor: color, andIntensity: intensity, for: layer)
  }
  
  func addBlackAndWhiteFilter(for layer: CALayer, withIntensity intensity: CGFloat) {
    let filterName = "CIColorControls"
    let saturationValue = mapValue(intensity, fromRange: (0, 1), toRange: (1, -1))
    let parameters = [ "inputSaturation": saturationValue ]
    updateFilter(layer: layer, filterName: filterName, newParameters: parameters)
  }
  
  func addNewOverlay(withColor color: CGColor, andIntensity intensity: CGFloat, for layer: CALayer) {
    let overlay = CALayer()
    overlay.frame = CGRect(origin: .zero, size: layer.frame.size)
    overlay.backgroundColor = color
    overlay.opacity = Float(intensity)
    layer.addSublayer(overlay)
  }
}
