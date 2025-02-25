//
//  VideoEditor.swift
//  auto_maker
//
//  Created by Quang Tinh Ngo on 4/13/24.
//

import Cocoa
import AVFoundation
import CoreImage

@objc protocol AMProcessorDelegate: NSObjectProtocol {
  @objc optional func progress(_ progress: Float)
  @objc optional func message(_ message: String)
}

extension AMProcessor {
  private func startProgressTimer() {
    progressTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(progressTimerHandle), userInfo: nil, repeats: true)
  }
  
  @objc private func progressTimerHandle() {
    self.delegate?.progress?(assetExport.progress)
  }
  
  private func endProgressTimer() {
    progressTimer?.invalidate()
    progressTimer = nil
  }
}

class AMProcessor {
  var videoLayer: CALayer!
  var parentLayer: CALayer!
  var bgLayer: CALayer!
  var mixComposition: AVMutableComposition!
  var layerInstructions: [AVMutableVideoCompositionLayerInstruction]!
  var videoComposition: AVMutableVideoComposition!
  var audioMix: AVMutableAudioMix!
  var audioMixParametersArray: [AVAudioMixInputParameters]!
  var assetExport: AVAssetExportSession!
  
  var delegate: AMProcessorDelegate?
  var projFilePath: URL?
  var project: AMProject?
  
  private var progressTimer: Timer?
  static let shared = AMProcessor()
  
  private init() {}
  
  func process() throws {
    clean()
    try setup()
    try prepare()
    export()
  }
  
  func export() {
    assetExport?.exportAsynchronously {
      var message = ""
      switch self.assetExport!.status {
      case .completed:
        message = self.assetExport?.outputURL?.lastPathComponent ?? "Completed"
      case .failed:
        message = self.assetExport?.error?.localizedDescription ?? "Failed"
      default:
        message = self.assetExport?.error?.localizedDescription ?? "Unknown Error"
      }
      self.endProgressTimer()
      DispatchQueue.main.async { self.delegate?.message?(message) }
    }
  }
  
  func prepare() throws {
//    try addBlankVideo()
    
    var sounds = project?.timeLine?.sounds() ?? []
    sounds.sort { $0.startTime() < $1.startTime() }
    for sound in sounds {
      try addSoundScript(sound)
    }
    
    var videos = project?.timeLine?.videos() ?? []
    videos.sort { $0.layer() > $1.layer() }
    for video in videos {
      try addVideoScript(video)
    }
    
    var imagesAndTexts = project?.timeLine?.imagesAndTexts() ?? []
    imagesAndTexts = imagesAndTexts.sorted { $0.layer() < $1.layer() }
    for baseScript in imagesAndTexts {
      if let imageScript = baseScript as? AMImageScript {
        try addImageScript(imageScript)
      } else if let textScript = baseScript as? AMTextScript {
        try addTextScript(textScript)
      }
    }
    
    videoComposition.animationTool = AVVideoCompositionCoreAnimationTool(postProcessingAsVideoLayer: videoLayer, in: parentLayer)
    
    let instruction = AVMutableVideoCompositionInstruction()
    instruction.timeRange = CMTimeRange(start: .zero, duration: project?.timeLine?.endTime() ?? .zero)
    instruction.backgroundColor = .clear
    instruction.layerInstructions = layerInstructions
    
    videoComposition.instructions = [instruction]
    assetExport?.videoComposition = videoComposition
    startProgressTimer()
    audioMix.inputParameters = audioMixParametersArray
    assetExport.audioMix = audioMix
  }
  
  func setup() throws {
    self.project = try AMProject.amProject(fromFilePath: projFilePath!)
    self.videoLayer = CALayer()
    self.videoLayer.frame = CGRect(origin: .zero, size: project!.projectSett!.canvasDimensions()!)
    self.videoLayer.backgroundColor = .clear
    self.bgLayer = CALayer()
    self.bgLayer.frame = CGRect(origin: .zero, size: project!.projectSett!.canvasDimensions()!)
    self.bgLayer.backgroundColor = project?.projectSett?.color()?.cgColor()
    self.parentLayer = CALayer()
    self.parentLayer.frame = CGRect(origin: .zero, size: project!.projectSett!.canvasDimensions()!)
    self.parentLayer.addSublayer(bgLayer)
    self.parentLayer.addSublayer(videoLayer)
    self.mixComposition = AVMutableComposition()
    self.layerInstructions = [AVMutableVideoCompositionLayerInstruction]()
    self.videoComposition = AVMutableVideoComposition()
    self.videoComposition.frameDuration = project!.projectSett!.frameDuration()!
    self.videoComposition.renderSize = project!.projectSett!.canvasDimensions()!
    self.audioMix = AVMutableAudioMix()
    self.audioMixParametersArray = [AVAudioMixInputParameters]()
    self.assetExport = AVAssetExportSession(asset: mixComposition, presetName: project!.advancedSett!.preset()!)
    self.assetExport.outputURL = project!.exportSett!.filePath()!.unique()
    self.assetExport.outputFileType = project!.exportSett!.outputFileType()!
  }
  
  func clean() {
    self.endProgressTimer()
    self.project = nil
    self.videoLayer = nil
    self.parentLayer = nil
    self.bgLayer = nil
    self.mixComposition = nil
    self.layerInstructions = nil
    self.videoComposition = nil
    self.audioMix = nil
    self.audioMixParametersArray = nil
    self.assetExport = nil
  }
  
  func addBlankVideo() throws {
    let path = Bundle.main.path(forResource: "blank", ofType: "mp4")!
    let jsonString = """
    {
      "layer": 0,
      "startTime": 0.0,
      "trim": { "start": 0.0, "end": 0.001 },
      "frame": {
        "point": { "x": 0.0, "y": 0.0 },
        "size": { "width": 20.0, "height": 20.0 }
      },
      "url": "\(path)",
      "opacity": 0.0
    }
    """
    if let videoScript = AMVideoScript(JSONString: jsonString) {
      try addVideoScript(videoScript)
    } else {
      throw error(description: "VideoEditor/addBlankVideo: videoScript is nil")
    }
  }
}
