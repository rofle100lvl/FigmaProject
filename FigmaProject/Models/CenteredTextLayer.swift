//
//  CenteredTextLayer.swift
//  FigmaProject
//
//  Created by Roman Gorbenko on 24/03/23.
//

import Foundation
import CoreGraphics
import QuartzCore

public class CenterTextLayer: CATextLayer {

  public override init() {
    super.init()
  }

  public override init(layer: Any) {
    super.init(layer: layer)
  }

  public required init(coder aDecoder: NSCoder) {
    super.init(layer: aDecoder)
  }

//    public override func draw(in ctx: CGContext) {
//        let multiplier = CGFloat(1)
//        
//        let yDiff = (bounds.size.height - ((string as? NSAttributedString)?.size().height ?? fontSize)) / 2 * multiplier
//        
//        ctx.saveGState()
//        ctx.translateBy(x: 0.0, y: yDiff)
//        super.draw(in: ctx)
//        ctx.restoreGState()
//    }
}
