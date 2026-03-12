//
//  Sound.swift
//  auto_maker
//
//  Created by Ngo Quang Tinh on 8/6/24.
//

import Cocoa
import AVFoundation

extension AMProcessor {
  func addSoundScript(_ soundScript: AMSoundScript) throws {
    let track = try addMutableTrack(withMediaType: .audio)
    let asset = soundScript.asset()
    let assetTrack = try asset.assetTrack(withMediaType: .audio)
    let params = AVMutableAudioMixInputParameters(track: assetTrack)
    params.trackID = track.trackID
    
    // - Fade
    if let fade = soundScript.fade() {
      let durationIn = CMTime(seconds: fade.fadeIn(), preferredTimescale: kTimeScale)
      let fadeIn = CMTimeRange(start: soundScript.startTime(), duration: durationIn)
      let seconds = (soundScript.startTime().seconds+soundScript.trim().duration.seconds) - fade.fadeOut()
      let start = CMTime(seconds: seconds, preferredTimescale: kTimeScale)
      let durationOut = CMTime(seconds: fade.fadeOut(), preferredTimescale: kTimeScale)
      let fadeOut = CMTimeRange(start: start, duration: durationOut)
      params.setVolumeRamp(fromStartVolume: .zero, toEndVolume: soundScript.volume(), timeRange: fadeIn)
      params.setVolumeRamp(fromStartVolume: soundScript.volume(), toEndVolume: .zero, timeRange: fadeOut)
    } else {
      // - Volume
      params.setVolume(soundScript.volume(), at: .zero)
    }
    audioMixParametersArray.append(params)
    
    // - Trim, Asset (File Path) and Start Time
    try track.insertTimeRange(soundScript.trim(), of: assetTrack, at: soundScript.startTime())
  }
}
