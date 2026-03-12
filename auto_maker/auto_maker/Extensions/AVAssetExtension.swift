//
//  AVURLAssetExtension.swift
//  auto_maker
//
//  Created by Quang Tinh Ngo on 5/6/24.
//

import AVFoundation

extension AVAsset {
  func assetTrack(withMediaType mediaType: AVMediaType) throws -> AVAssetTrack {
    if let result = self.tracks(withMediaType: mediaType).first {
      return result
    } else {
      throw error(description: "AVAsset/assetTrack: tracks are nil")
    }
  }
}
