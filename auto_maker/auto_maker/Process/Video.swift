//
//  Video.swift
//  auto_maker
//
//  Created by Ngo Quang Tinh on 8/6/24.
//

import Cocoa
import AVFoundation

extension AMProcessor {
  func addVideoScript(_ videoScript: AMVideoScript) throws {
    let asset = videoScript.asset()
    let assetTrack = try asset.assetTrack(withMediaType: .video)
    let compositionTrack = try addMutableTrack(withMediaType: .video)
    try compositionTrack.insertTimeRange(videoScript.trim(), of: assetTrack, at: videoScript.startTime())
    let layerInstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: compositionTrack)
    
    let scaleX = try videoScript.frame().width/videoScript.crop().width
    let scaleY = try videoScript.frame().height/videoScript.crop().height
    
    // Crop
    layerInstruction.setCropRectangle(try videoScript.crop(), at: .zero)
    let translationX = try (-1)*(videoScript.crop().origin.x)*scaleX + videoScript.frame().origin.x
    let translationY = try (-1)*(videoScript.crop().origin.y)*scaleY + videoScript.frame().origin.y
    var transform = CGAffineTransform(translationX: translationX, y: translationY)
    
    // Frame
    transform = transform.scaledBy(x: scaleX, y: scaleY)
    
    // Rotation
//    var angle = videoScript.rotate().truncatingRemainder(dividingBy: 360)
//    angle /= 360
//    angle *= (.pi*2)
//    transform = transform.rotated(by: angle)
    layerInstruction.setTransform(transform, at: videoScript.startTime())
    
    // Opacity
//    if let transparency = videoScript.colorAdjuster()?.transparency() {
//      layerInstruction.setOpacity(transparency, at: .zero)
//    }
    
    // Fade
//    if let fade = videoScript.fade() {
//      let opacity = videoScript.colorAdjuster()?.transparency() ?? 1
//
//      let fadeInTimeRange = CMTimeRange(start: videoScript.startTime(),
//                                        duration: CMTime(seconds: fade.fadeIn(), preferredTimescale: kTimeScale))
//      layerInstruction.setOpacityRamp(fromStartOpacity: 0, toEndOpacity: opacity, timeRange: fadeInTimeRange)
//      let fadeOutTimeRange = CMTimeRange(start: videoScript.endTime()-CMTime(seconds: fade.fadeOut(), preferredTimescale: kTimeScale),
//                                         duration: CMTime(seconds: fade.fadeOut(), preferredTimescale: kTimeScale))
//      layerInstruction.setOpacityRamp(fromStartOpacity: opacity, toEndOpacity: 0, timeRange: fadeOutTimeRange)
//    }
    
    // Hide
    let hideTransform = CGAffineTransform(scaleX: .greatestFiniteMagnitude, y: .greatestFiniteMagnitude)
    layerInstruction.setTransform(hideTransform, at: videoScript.endTime())
    
    self.layerInstructions.append(layerInstruction)
  }
}
