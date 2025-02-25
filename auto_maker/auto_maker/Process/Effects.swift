//
//  Effect.swift
//  auto_maker
//
//  Created by Ngo Quang Tinh on 8/6/24.
//

import Cocoa

extension AMProcessor {
  func addFlashEffect(_ flash: QTFlashEffect, for layer: CALayer, beginTime: Double) {
    let duration = (4)*mapValue(CGFloat(flash.speed()), fromRange: (0, 1), toRange: (1, 0.001))
    
    if flash.isFade() {
      let animation = CABasicAnimation(keyPath: "opacity")
      animation.beginTime = beginTime-0.0001
      animation.fromValue = layer.opacity
      animation.toValue = 0
      animation.duration = Double(duration)
      animation.autoreverses = true
      animation.repeatCount = .infinity
      animation.fillMode = .forwards
      animation.isRemovedOnCompletion = false
      layer.add(animation, forKey: UUID().uuidString)
    } else {
      let animation = CAKeyframeAnimation(keyPath: "hidden")
      animation.beginTime = beginTime-0.0001
      animation.values = [false, false, true, true]
      animation.keyTimes = [0.0, 0.5, 0.5, 1.0]
      animation.duration = Double(duration)*2
      animation.repeatCount = .infinity
      animation.fillMode = .forwards
      animation.isRemovedOnCompletion = false
      layer.add(animation, forKey: UUID().uuidString)
    }
  }
  
  func addShakeEffect(_ shake: QTShakeEffect, for layer: CALayer, beginTime: Double) {
    let duration = (3)*mapValue(CGFloat(shake.speed()), fromRange: (0, 1), toRange: (1, 0.001))
    
    let r0 = degreesToRadians(0)
    let r20 = degreesToRadians(20)
    
    let animation = CAKeyframeAnimation(keyPath: "transform.rotation")
    animation.beginTime = beginTime-0.0001
    animation.values = [r0, -r20, r0, r20, r0]
    animation.keyTimes = [0.0, 0.25, 0.5, 0.75, 1.0]
    animation.duration = Double(duration)
    animation.repeatCount = .infinity
    animation.fillMode = .forwards
    animation.isRemovedOnCompletion = false
    layer.add(animation, forKey: UUID().uuidString)
  }
  
  func addPulseEffect(_ pulse: QTPulseEffect, for layer: CALayer, beginTime: Double) {
    let duration = (3)*mapValue(pulse.speed(), fromRange: (0, 1), toRange: (1, 0.05))
    let repeatCount: Float = pulse.isLoop() ? .infinity : 1.0
    let amount = mapValue(pulse.amount(), fromRange: (0, 1), toRange: (1.02, 1.5))
    
    let animation = CABasicAnimation(keyPath: "transform.scale")
    animation.beginTime = beginTime-0.0001
    animation.fromValue = 1
    animation.toValue = amount
    animation.duration = Double(duration)
    animation.autoreverses = true
    animation.repeatCount = repeatCount
    animation.fillMode = .forwards
    animation.isRemovedOnCompletion = false
    layer.add(animation, forKey: UUID().uuidString)
  }
  
  func screenGreen(_ greenscreening: QTGreenscreeningEffect, for layer: CALayer) {
    let threshold = greenscreening.screenThreshold()
    var fromHue: CGFloat = 0
    var toHue: CGFloat = 0
    
    if greenscreening.screenColor() == "red" {
      fromHue = 330+(threshold*45)
      fromHue = fromHue > 360 ? (fromHue-360) : fromHue
      toHue = 60-(threshold*45)
    } else if greenscreening.screenColor() == "blue" {
      fromHue = 180+(threshold*45)
      toHue = 270-(threshold*45)
    } else {
      fromHue = 90+(threshold*45)
      toHue = 180-(threshold*45)
    }
    
    fromHue /= 360
    toHue /= 360
    
    let filterName = "CIColorCube"
    let parameters = chromaKeyFilterParams(fromHue: fromHue, toHue: toHue)
    updateFilter(layer: layer, filterName: filterName, newParameters: parameters)
  }
  
  func addSlowZoomEffect(_ slowZoom: QTSlowZoomEffect, for layer: CALayer, in duration: Double, beginTime: Double) {
    let scale = mapValue(slowZoom.speed(), fromRange: (0, 1), toRange: (1.1, 3))
    
    if slowZoom.position() == "center" {
      let animation = CABasicAnimation(keyPath: "transform.scale")
      animation.beginTime = beginTime-0.0001
      animation.duration = duration
      animation.repeatCount = 1
      animation.fillMode = .forwards
      animation.isRemovedOnCompletion = false
      if slowZoom.isReverse() {
        animation.fromValue = scale
        animation.toValue = 1
      } else {
        animation.fromValue = 1
        animation.toValue = scale
      }
      layer.add(animation, forKey: UUID().uuidString)
    }
  }
  
  func addSpinEffect(_ spin: QTSpinEffect, for layer: CALayer, beginTime: Double) {
    let animation = CAKeyframeAnimation(keyPath: "transform.rotation")
    
    var duration: Double!
    var values: [CGFloat]!
    var keyTimes: [NSNumber]!
    
    let r0 = degreesToRadians(0)
    let r360 = degreesToRadians(360)
    
    if spin.isBounce() {
      let r45 = degreesToRadians(45)
      let r20 = degreesToRadians(20)
      duration = 2
      values = [r0, -r45, r20+r360, r360-r20/2, r360]
      keyTimes = [0, 0.25, 0.75, 0.85, 1]
    } else {
      duration = 1
      values = [r0, r360]
      keyTimes = [0, 1]
    }
    
    if spin.isReverse() {
      for i in 0..<values.count { values[i] *= -1 }
    }
    
    let repeatCount = spin.isLoop() ? Float.infinity : 1.0
    
    animation.beginTime = beginTime-0.0001
    animation.values = values
    animation.keyTimes = keyTimes
    animation.duration = duration
    animation.repeatCount = repeatCount
    animation.fillMode = .forwards
    animation.isRemovedOnCompletion = false
    layer.add(animation, forKey: UUID().uuidString)
  }
  
//  func addVHSEffect(_ vhs: QTVHSEffect, for layer: CALayer) {
//    let colorMonochromeFilterName = "CIColorMonochrome"
//    let parameters = [ "inputIntensity": vhs.intensity() ]
//    updateFilter(layer: layer, filterName: colorMonochromeFilterName, newParameters: parameters)
//
//    let grain = mapValue(vhs.grain(), fromRange: (0, 1), toRange: (0, 0.5))
//
//    let noiseFilterLayer = CALayer()
//    noiseFilterLayer.frame = CGRect(origin: .zero, size: layer.frame.size)
//    noiseFilterLayer.opacity = Float(grain)
//    layer.addSublayer(noiseFilterLayer)
//
//    let noiseLayer1 = CALayer()
//    noiseLayer1.frame = noiseFilterLayer.frame
//    updateFilter(layer: noiseLayer1, filterName: "CIRandomGenerator", newParameters: [:])
//
//    let noiseLayer2 = CALayer()
//    noiseLayer2.frame = noiseFilterLayer.frame
//    noiseLayer2.frame.origin.x += 1
//    noiseLayer2.frame.origin.y += 1
//    updateFilter(layer: noiseLayer2, filterName: "CIRandomGenerator", newParameters: [:])
//
//    let noiseLayer3 = CALayer()
//    noiseLayer3.frame = noiseFilterLayer.frame
//    updateFilter(layer: noiseLayer3, filterName: "CIRandomGenerator", newParameters: [:])
//
//    noiseFilterLayer.addSublayer(noiseLayer1)
//    noiseFilterLayer.addSublayer(noiseLayer2)
////    noiseFilterLayer.addSublayer(noiseLayer3)
//
//    let noiseAnimation1 = CAKeyframeAnimation(keyPath: "hidden")
//    noiseAnimation1.beginTime = -0.0001
//    noiseAnimation1.values = [false, true, false, true, false]
//    noiseAnimation1.keyTimes = [0.0, 0.25, 0.5, 0.75, 1.0]
//    noiseAnimation1.duration = 0.25
//    noiseAnimation1.repeatCount = .infinity
//    noiseAnimation1.fillMode = .forwards
//    noiseAnimation1.isRemovedOnCompletion = false
//    noiseLayer1.add(noiseAnimation1, forKey: UUID().uuidString)
//
//    let noiseAnimation2 = CAKeyframeAnimation(keyPath: "hidden")
//    noiseAnimation2.beginTime = -0.0001
//    noiseAnimation2.values = [true, false, true, false, true]
//    noiseAnimation2.keyTimes = [0.0, 0.25, 0.5, 0.75, 1.0]
//    noiseAnimation2.duration = 0.25
//    noiseAnimation2.repeatCount = .infinity
//    noiseAnimation2.fillMode = .forwards
//    noiseAnimation2.isRemovedOnCompletion = false
//    noiseLayer2.add(noiseAnimation2, forKey: UUID().uuidString)
//  }
  
  func addRotationEffect(_ rotation: QTRotationEffect, for layer: CALayer, beginTime: Double) {
    let duration = (20)*mapValue(rotation.speed(), fromRange: (0, 1), toRange: (1, 0.03))
    
    let r0 = degreesToRadians(0)
    let r360 = degreesToRadians(360)
    
    var values = [r0, r360]
    let keyTimes: [NSNumber] = [0.0, 1.0]
    
    if rotation.isReverse() {
      for i in 0..<values.count { values[i] *= -1 }
    }
    
    let animation = CAKeyframeAnimation(keyPath: "transform.rotation")
    animation.beginTime = beginTime-0.0001
    animation.values = values
    animation.keyTimes = keyTimes
    animation.duration = Double(duration)
    animation.repeatCount = .infinity
    animation.fillMode = .forwards
    animation.isRemovedOnCompletion = false
    layer.add(animation, forKey: UUID().uuidString)
  }
  
  func addBlurEffect(_ blur: QTBlurEffect, for layer: CALayer) {
    let inputRadius = mapValue(blur.value(), fromRange: (0, 1), toRange: (10, 200))
    let filterName = "CIGaussianBlur"
    let parameters = [ "inputRadius": inputRadius ]
    updateFilter(layer: layer, filterName: filterName, newParameters: parameters)
  }
  
  func addDiscoEffect(for layer: CALayer) {
    let filterLayer = CALayer()
    filterLayer.frame.origin = .zero
    filterLayer.frame.size = layer.frame.size
    filterLayer.backgroundColor = NSColor.red.cgColor
    filterLayer.opacity = 0.2
    layer.addSublayer(filterLayer)
    
    let values = [
      NSColor.red.cgColor,
      NSColor.red.cgColor,
      NSColor.green.cgColor,
      NSColor.green.cgColor,
      NSColor.blue.cgColor,
      NSColor.blue.cgColor,
      NSColor.purple.cgColor,
      NSColor.purple.cgColor,
      NSColor.yellow.cgColor,
      NSColor.yellow.cgColor,
      NSColor.cyan.cgColor,
      NSColor.cyan.cgColor
    ]
    let keyTimes: [NSNumber] = [0, 0.2, 0.2, 0.4, 0.4, 0.6, 0.6, 0.8, 0.8, 1]
    
    let animation = CAKeyframeAnimation(keyPath: "backgroundColor")
    animation.beginTime = -0.0001
    animation.values = values
    animation.keyTimes = keyTimes
    animation.duration = 2
    animation.repeatCount = .infinity
    animation.fillMode = .forwards
    animation.isRemovedOnCompletion = false
    filterLayer.add(animation, forKey: UUID().uuidString)
  }
  
  func addColorShiftEffect(for layer: CALayer) {
    let filterName = "CIHueAdjust"
    let parameters = [ "inputAngle": 0 ]
    updateFilter(layer: layer, filterName: filterName, newParameters: parameters)
    
    let values: [NSNumber] = [0, 60, 60, 120, 120, 180, 180, 240, 240, 300, 300, 360]
    let keyTimes: [NSNumber] = [0, 0.2, 0.2, 0.4, 0.4, 0.6, 0.6, 0.8, 0.8, 1]
    
    let animation = CAKeyframeAnimation(keyPath: "filters.CIHueAdjust.inputAngle")
    animation.beginTime = -0.0001
    animation.values = values
    animation.keyTimes = keyTimes
    animation.duration = 200
    animation.repeatCount = .infinity
    animation.fillMode = .forwards
    animation.isRemovedOnCompletion = false
    layer.add(animation, forKey: UUID().uuidString)
  }
}
