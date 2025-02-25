//
//  CALayerExtension.swift
//  auto_maker
//
//  Created by Ngo Quang Tinh on 7/10/24.
//

import Cocoa

extension CALayer {
  func rotate(degree: CGFloat) {
    var angle = degree.truncatingRemainder(dividingBy: 360)
    angle /= 360
    angle *= (.pi*2)
    self.transform = CATransform3DMakeRotation(angle, .zero, .zero, 1)
  }
  
  func setShadow(with shadow: QTShadow) {
    self.shadowColor = shadow.color().cgColor
    self.shadowOffset.width = shadow.offset().width
    self.shadowOffset.height = (-1)*shadow.offset().height
    self.shadowOpacity = shadow.opacity()
    self.shadowRadius = shadow.radius()
  }
}
