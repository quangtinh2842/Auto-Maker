//
//  Text.swift
//  auto_maker
//
//  Created by Ngo Quang Tinh on 8/6/24.
//

import Cocoa
import AVFoundation

extension AMProcessor {
  func addTextScript(_ textScript: AMTextScript) throws {
    if textScript.timeRange().duration.seconds == .zero {
      throw error(description: "VideoEditor/addTextScript: duration is zero")
    }
    
    let path = Bundle.main.path(forResource: "blank", ofType: "mp4")!
    let url = URL(fileURLWithPath: path)
    let asset = AVAsset(url: url)
    let track = try addMutableTrack(withMediaType: .audio)
    let trackAsset = try asset.assetTrack(withMediaType: .audio)
    let timeRange = CMTimeRange(start: .zero, duration: CMTime(seconds: 1.0/Double(kTimeScale), preferredTimescale: kTimeScale))
    try track.insertTimeRange(timeRange, of: trackAsset, at: textScript.endTime()-1.0/Double(kTimeScale))
    
    let textLayer = QTTextLayer()
    textLayer.string = textScript.string()
    textLayer.frame.origin = .zero
    textLayer.frame.size = textScript.frame().size
    textLayer.foregroundColor = textScript.foregroundColor().cgColor
    textLayer.alignmentMode = .center
    textLayer.font = try textScript.font()
    textLayer.fontSize = textScript.fontSize()
    textLayer.strokeWidth = textScript.strokeWidth()
    textLayer.strokeColor = textScript.strokeColor()
    textLayer.backgroundColor = textScript.backgroundColor().cgColor
    textLayer.isWrapped = true
    textLayer.displayIfNeeded()
    textLayer.setNeedsDisplay()
    
    let textLayerContainer = CALayer()
    textLayerContainer.frame.origin = CGPoint(x: textScript.borderWidth(), y: textScript.borderWidth())
    textLayerContainer.frame.size = textLayer.frame.size
    textLayerContainer.backgroundColor = .clear
    textLayerContainer.addSublayer(textLayer)
    
    // - Color Adjuster
    if let colorAdjuster = textScript.colorAdjuster() {
      adjustColor(for: textLayer, with: colorAdjuster)
    }
    
    // - Filters
    if let filters = textScript.filters() {
      addFilters(filters, for: textLayerContainer)
    }
    
    let boundLayer = CALayer()
    boundLayer.frame.origin = .zero
    boundLayer.frame.size = textScript.frame().size
    boundLayer.frame.size.width += textScript.borderWidth()*2
    boundLayer.frame.size.height += textScript.borderWidth()*2
    boundLayer.addSublayer(textLayerContainer)
    boundLayer.borderWidth = textScript.borderWidth()
    boundLayer.borderColor = textScript.borderColor().cgColor
    boundLayer.cornerRadius = textScript.cornerRadius()
    boundLayer.masksToBounds = true
    
    let shadowLayer = CALayer()
    shadowLayer.frame.origin = .zero
    shadowLayer.frame.size = boundLayer.frame.size
    shadowLayer.addSublayer(boundLayer)
    if let shadow = textScript.shadow() {
      shadowLayer.setShadow(with: shadow)
    }
    
    let frameLayer = CALayer()
    frameLayer.frame.origin = textScript.frame().origin
    frameLayer.frame.size = boundLayer.frame.size
    frameLayer.frame.origin.y = project!.projectSett!.canvasDimensions()!.height-frameLayer.frame.height-textScript.frame().origin.y-textScript.borderWidth()*2
    frameLayer.rotate(degree: textScript.rotate())
    
    // - Effects
    if let effects = textScript.effects() {
      if let flash = effects.flash() {
        let beginTime = textScript.startTime().seconds
        addFlashEffect(flash, for: boundLayer, beginTime: beginTime)
      }
      
      if let shake = effects.shake() {
        let beginTime = textScript.startTime().seconds
        addShakeEffect(shake, for: boundLayer, beginTime: beginTime)
      }
      
      if let pulse = effects.pulse() {
        let beginTime = textScript.startTime().seconds
        addPulseEffect(pulse, for: boundLayer, beginTime: beginTime)
      }
      
      if let greenscreening = effects.greenscreening() {
        screenGreen(greenscreening, for: textLayer)
      }
      
      if let slowZoom = effects.slowZoom() {
        let beginTime = textScript.startTime().seconds
        let duration = textScript.timeRange().duration.seconds
        addSlowZoomEffect(slowZoom, for: boundLayer, in: duration, beginTime: beginTime)
      }
      
      if let spin = effects.spin() {
        let beginTime = textScript.startTime().seconds
        addSpinEffect(spin, for: boundLayer, beginTime: beginTime)
      }
      
//      if let vhs = effects.vhs() {
//        addVHSEffect(vhs, for: textLayerContainer)
//      }
      
      if let rotation = effects.rotation() {
        let beginTime = textScript.startTime().seconds
        addRotationEffect(rotation, for: boundLayer, beginTime: beginTime)
      }
      
      if let blur = effects.blur() {
        addBlurEffect(blur, for: textLayerContainer)
      }
      
      if effects.isDisco() {
        addDiscoEffect(for: textLayerContainer)
      }
      
      if effects.isColorShift() {
        addColorShiftEffect(for: textLayerContainer)
      }
    }
    
    frameLayer.addSublayer(shadowLayer)
    
    if let fade = textScript.fade() {
      let start = textScript.startTime().seconds
      let end = textScript.endTime().seconds
      addFade(fade, for: frameLayer, start: start, end: end)
    }
    
    if let bright = textScript.bright() {
      let start = textScript.startTime().seconds
      let end = textScript.endTime().seconds
      addBright(bright, for: frameLayer, start: start, end: end)
    }
    
    let fromShow = textScript.startTime().seconds
    let toShow = textScript.endTime().seconds
    showLayer(frameLayer, from: fromShow, to: toShow)
    
    parentLayer.addSublayer(frameLayer)
  }
}
