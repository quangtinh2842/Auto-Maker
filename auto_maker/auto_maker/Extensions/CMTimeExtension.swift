//
//  CMTimeExtension.swift
//  auto_maker
//
//  Created by Quang Tinh Ngo on 6/13/24.
//

import AVFoundation

extension CMTime {
  static func -(lhs: CMTime, rhs: Double) -> CMTime {
    let rhsTime = CMTime(seconds: rhs, preferredTimescale: lhs.timescale)
    return lhs - rhsTime
  }
}
