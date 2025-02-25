//
//  Image.swift
//  auto_maker
//
//  Created by Ngo Quang Tinh on 8/6/24.
//

import Cocoa
import AVFoundation

extension AMProcessor {
  func addImageScript(_ imageScript: AMImageScript) throws {
    if imageScript.timeRange().duration.seconds == .zero {
      throw error(description: "VideoEditor/addImageScript: duration is zero")
    }
    
    let path = Bundle.main.path(forResource: "blank", ofType: "mp4")!
    let url = URL(fileURLWithPath: path)
    let asset = AVAsset(url: url)
    let track = try addMutableTrack(withMediaType: .audio)
    let trackAsset = try asset.assetTrack(withMediaType: .audio)
    let timeRange = CMTimeRange(start: .zero, duration: CMTime(seconds: 1.0/Double(kTimeScale), preferredTimescale: kTimeScale))
    try track.insertTimeRange(timeRange, of: trackAsset, at: imageScript.endTime()-1.0/Double(kTimeScale))
    
    let image = try imageScript.nsImage()
    let imageLayer = CALayer()
    imageLayer.frame.size = image.size
    imageLayer.frame.origin.x = try -imageScript.crop().origin.x
    imageLayer.frame.origin.y = try imageScript.crop().origin.y - (image.size.height-imageScript.crop().height)
    var imageRect = CGRect(origin: .zero, size: image.size)
    let cgImage = image.cgImage(forProposedRect: &imageRect, context: nil, hints: nil)
    imageLayer.contents = cgImage
    
    // - Color Adjuster
    if let colorAdjuster = imageScript.colorAdjuster() {
      adjustColor(for: imageLayer, with: colorAdjuster)
    }
    
    let cropLayer = CALayer()
    cropLayer.frame.size = try imageScript.crop().size
    let sx = try imageScript.frame().width/imageScript.crop().width
    let sy = try imageScript.frame().height/imageScript.crop().height
    cropLayer.transform = CATransform3DMakeScale(sx, sy, 1)
    cropLayer.frame.origin.x = imageScript.borderWidth()
    cropLayer.frame.origin.y = imageScript.borderWidth()
    cropLayer.addSublayer(imageLayer)
    
    let borderLayer = CALayer()
    borderLayer.frame.size = try imageScript.frame().size
    borderLayer.frame.size.width += imageScript.borderWidth()*2
    borderLayer.frame.size.height += imageScript.borderWidth()*2
    borderLayer.frame.origin = .zero
    borderLayer.cornerRadius = imageScript.cornerRadius()
    borderLayer.borderWidth = imageScript.borderWidth()
    borderLayer.borderColor = imageScript.borderColor().cgColor
    borderLayer.backgroundColor = imageScript.backgroundColor().cgColor
    borderLayer.addSublayer(cropLayer)
    borderLayer.masksToBounds = true
    
    // - Filters
    if let filters = imageScript.filters() {
      addFilters(filters, for: borderLayer)
    }
    
    let boundLayer = CALayer()
    boundLayer.frame.origin = .zero
    boundLayer.frame.size = borderLayer.frame.size
    boundLayer.addSublayer(borderLayer)
    
    // - Effects
    if let effects = imageScript.effects() {
      if let flash = effects.flash() {
        let beginTime = imageScript.startTime().seconds
        addFlashEffect(flash, for: boundLayer, beginTime: beginTime)
      }
      
      if let shake = effects.shake() {
        let beginTime = imageScript.startTime().seconds
        addShakeEffect(shake, for: boundLayer, beginTime: beginTime)
      }
      
      if let pulse = effects.pulse() {
        let beginTime = imageScript.startTime().seconds
        addPulseEffect(pulse, for: boundLayer, beginTime: beginTime)
      }
      
      if let greenscreening = effects.greenscreening() {
        screenGreen(greenscreening, for: imageLayer)
      }
      
      if let slowZoom = effects.slowZoom() {
        let beginTime = imageScript.startTime().seconds
        let duration = imageScript.timeRange().duration.seconds
        addSlowZoomEffect(slowZoom, for: boundLayer, in: duration, beginTime: beginTime)
      }
      
      if let spin = effects.spin() {
        let beginTime = imageScript.startTime().seconds
        addSpinEffect(spin, for: boundLayer, beginTime: beginTime)
      }
      
      if let rotation = effects.rotation() {
        let beginTime = imageScript.startTime().seconds
        addRotationEffect(rotation, for: boundLayer, beginTime: beginTime)
      }
      
      if let blur = effects.blur() {
        addBlurEffect(blur, for: imageLayer)
      }
      
      if effects.isDisco() {
        addDiscoEffect(for: imageLayer)
      }
      
      if effects.isColorShift() {
        addColorShiftEffect(for: imageLayer)
      }
    }
    
    let shadowLayer = CALayer()
    shadowLayer.frame.origin = .zero
    shadowLayer.frame.size = borderLayer.frame.size
    shadowLayer.addSublayer(boundLayer)
    if let shadow = imageScript.shadow() {
      shadowLayer.setShadow(with: shadow)
    }
    
    let frameLayer = CALayer()
    frameLayer.frame = try imageScript.frame()
    frameLayer.frame.origin.y = try project!.projectSett!.canvasDimensions()!.height-frameLayer.frame.height-imageScript.frame().origin.y-imageScript.borderWidth()*2
    frameLayer.frame.size = shadowLayer.frame.size
    frameLayer.addSublayer(shadowLayer)
    frameLayer.rotate(degree: imageScript.rotate())
    
    if let fade = imageScript.fade() {
      let start = imageScript.startTime().seconds
      let end = imageScript.endTime().seconds
      addFade(fade, for: frameLayer, start: start, end: end)
    }
    
    if let bright = imageScript.bright() {
      let start = imageScript.startTime().seconds
      let end = imageScript.endTime().seconds
      addBright(bright, for: frameLayer, start: start, end: end)
    }
    
    let fromShow = imageScript.startTime().seconds
    let toShow = imageScript.endTime().seconds
    showLayer(frameLayer, from: fromShow, to: toShow)
    
    parentLayer.addSublayer(frameLayer)
  }
}
