//
//  ColorAdjustment.swift
//  auto_maker
//
//  Created by Ngo Quang Tinh on 8/6/24.
//

import Cocoa

extension AMProcessor {
  func adjustColor(for layer: CALayer, with colorAdjuster: QTColorAdjuster) {
    let exposure = colorAdjuster.exposure()
    adjustExposure(exposure, for: layer)

    let contrast = colorAdjuster.contrast()
    adjustContrast(contrast, for: layer)

    let saturation = colorAdjuster.saturation()
    adjustSaturation(saturation, for: layer)
    
    let temperature = colorAdjuster.temperature()
    adjustTemperature(temperature, for: layer)
    
    let transparency = colorAdjuster.transparency()
    adjustTransparency(transparency, for: layer)
    
    let negative =  colorAdjuster.isNegative()
    adjust(layer: layer, toNegative: negative)
  }
  
  func adjustExposure(_ exposure: Double, for layer: CALayer) {
    let filterName = "CIExposureAdjust"
    let parameters = [ "inputEV": exposure ]
    updateFilter(layer: layer, filterName: filterName, newParameters: parameters)
  }
  
  func adjustContrast(_ contrast: Double, for layer: CALayer) {
    let filterName = "CIColorControls"
    let parameters = [ "inputContrast": contrast ]
    updateFilter(layer: layer, filterName: filterName, newParameters: parameters)
  }
  
  func adjustSaturation(_ saturation: Double, for layer: CALayer) {
    let filterName = "CIColorControls"
    let parameters = [ "inputSaturation": saturation ]
    updateFilter(layer: layer, filterName: filterName, newParameters: parameters)
  }
  
  func adjustTemperature(_ threshold: CGFloat, for layer: CALayer) {
    let minX: CGFloat = 0.1
    let minY: CGFloat = 0.2
    let midX: CGFloat = 0.3128
    let midY: CGFloat = 0.3293
    let maxX: CGFloat = midX*2-minX
    let maxY: CGFloat = midY*2-minY
    let x = mapValue(threshold, fromRange: (-1, 1), toRange: (minX, maxX))
    let y = mapValue(threshold, fromRange: (-1, 1), toRange: (minY, maxY))
    let filterName = "CITemperatureAndTint"
    let parameters = [
      "inputNeutral": CIVector(x: 6500, y: 0),
      "inputTargetNeutral": CIVector(x: x, y: y)
    ]
    updateFilter(layer: layer, filterName: filterName, newParameters: parameters)
  }
  
  func adjust(layer: CALayer, toNegative negative: Bool) {
    if negative {
      let filterName = "CIColorInvert"
      updateFilter(layer: layer, filterName: filterName, newParameters: [:])
    }
  }
  
  func adjustTransparency(_ transparency: Float, for layer: CALayer) {
    layer.opacity = 1-transparency
  }
}
