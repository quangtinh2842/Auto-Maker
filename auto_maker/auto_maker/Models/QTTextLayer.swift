//
//  QTTextLayer.swift
//  auto_maker
//
//  Created by Quang Tinh Ngo on 6/11/24.

import Cocoa

class QTTextLayer: CATextLayer {
  var strokeWidth: CGFloat = .zero
  var strokeColor: NSColor = .clear
  
  override func draw(in ctx: CGContext) {
    if let string = self.string as? String,
       let font = self.font as? NSFont {
      let height = string.heightWith(constrainedWidth: frame.width, font: font, fontSize: fontSize)
      let yDiff = frame.height/2 - height/2
      ctx.saveGState()
      ctx.setLineWidth(strokeWidth)
      ctx.setLineJoin(.round)
      ctx.setTextDrawingMode(.stroke)
      ctx.setStrokeColor(strokeColor.cgColor)
      ctx.translateBy(x: 0, y: -yDiff)
      super.draw(in: ctx)
      ctx.restoreGState()
      ctx.saveGState()
      ctx.setTextDrawingMode(.fill)
      ctx.setFillColor(foregroundColor!)
      ctx.translateBy(x: 0, y: -yDiff)
      super.draw(in: ctx)
      ctx.restoreGState()
    }
  }
}
