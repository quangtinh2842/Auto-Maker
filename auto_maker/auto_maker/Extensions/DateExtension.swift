//
//  DateExtension.swift
//  auto_maker
//
//  Created by Ngo Quang Tinh on 8/6/24.
//

import Foundation

extension Date {
  static func hhmmss() -> String {
    let date = Date()
    let calendar = Calendar.current
    let hour = calendar.component(.hour, from: date)
    let minutes = calendar.component(.minute, from: date)
    let sec = calendar.component(.second, from: date)
    return "\(hour):\(minutes):\(sec)"
  }
}
