//
//  Common.swift
//  auto_maker
//
//  Created by Ngo Quang Tinh on 8/6/24.
//

import AVFoundation
import Cocoa

extension AMProcessor {
  func showLayer(_ layer: CALayer, from: CFTimeInterval, to: CFTimeInterval) {
    layer.isHidden = true
    let appearAnimation = CABasicAnimation(keyPath: "hidden")
    appearAnimation.beginTime = from-0.0001
    appearAnimation.duration = 0.0001
    appearAnimation.fromValue = true
    appearAnimation.toValue = false
    appearAnimation.fillMode = .forwards
    appearAnimation.isRemovedOnCompletion = false
    layer.add(appearAnimation, forKey: UUID().uuidString)
    let disappearAnimation = CABasicAnimation(keyPath: "hidden")
    disappearAnimation.beginTime = to-0.0001
    disappearAnimation.duration = 0.0001
    disappearAnimation.fromValue = false
    disappearAnimation.toValue = true
    disappearAnimation.fillMode = .forwards
    disappearAnimation.isRemovedOnCompletion = false
    layer.add(disappearAnimation, forKey: UUID().uuidString)
  }
  
  func addFade(_ fade: QTFade, for layer: CALayer, start: CFTimeInterval, end: CFTimeInterval) {
    let preOpacity = layer.opacity
    layer.opacity = 0
    let fadeIn = CABasicAnimation(keyPath: "opacity")
    fadeIn.beginTime = start-0.0001
    fadeIn.duration = fade.fadeIn()+0.0001
    fadeIn.fromValue = 0
    fadeIn.toValue = preOpacity
    fadeIn.fillMode = .forwards
    fadeIn.isRemovedOnCompletion = false
    layer.add(fadeIn, forKey: UUID().uuidString)
    let fadeOut = CABasicAnimation(keyPath: "opacity")
    fadeOut.beginTime = end-fade.fadeOut()-0.0001
    fadeOut.duration = fade.fadeOut()+0.0001
    fadeOut.fromValue = preOpacity
    fadeOut.toValue = 0
    fadeOut.fillMode = .forwards
    fadeOut.isRemovedOnCompletion = false
    layer.add(fadeOut, forKey: UUID().uuidString)
  }
  
  func addBright(_ bright: QTBright, for layer: CALayer, start: CFTimeInterval, end: CFTimeInterval) {
    var preBrightness: NSNumber = 0
    if let brightnessValue = getValue(from: layer, filterName: "CIColorControls", parameterKey: "inputBrightness") as? NSNumber {
      preBrightness = brightnessValue
    }
    
    let brightIn = CABasicAnimation(keyPath: "filters.CIColorControls.inputBrightness")
    brightIn.beginTime = start-0.0001
    brightIn.duration = bright.brightIn()+0.0001
    brightIn.fromValue = 2
    brightIn.toValue = preBrightness
    brightIn.fillMode = .forwards
    brightIn.isRemovedOnCompletion = false
    layer.add(brightIn, forKey: UUID().uuidString)
    let brightOut = CABasicAnimation(keyPath: "filters.CIColorControls.inputBrightness")
    brightOut.beginTime = end-bright.brightOut()-0.0001
    brightOut.duration = bright.brightOut()+0.0001
    brightOut.fromValue = preBrightness
    brightOut.toValue = 2
    brightOut.fillMode = .forwards
    brightOut.isRemovedOnCompletion = false
    layer.add(brightOut, forKey: UUID().uuidString)
  }
  
  func addMutableTrack(withMediaType mediaType: AVMediaType) throws -> AVMutableCompositionTrack {
    if let track = mixComposition.addMutableTrack(withMediaType: mediaType, preferredTrackID: preferredTrackID) {
      return track
    } else {
      throw error(description: "VideoEditor/addMutableTrack: track is nil")
    }
  }
}
