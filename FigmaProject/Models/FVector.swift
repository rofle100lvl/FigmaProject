//
//  FVector.swift
//  FigmaProject
//
//  Created by Roman Gorbenko on 17/03/23.
//

import Foundation
import UIKit

struct DrawModel {
    var fillColor: UIColor?
    var strokeColor: (UIColor, CGFloat)?
}

class FVector: FView {
    var drawing: [DrawingCommand] = []
    var fills: [FPaint] = []
    var strokes: [FPaint] = []
    var strokeWeight: CGFloat? = nil
    
    var drawModel: DrawModel {
        var drawModel = DrawModel()
        if !self.fills.isEmpty,
           let solid = self.fills[0] as? FSolid {
            drawModel.fillColor = solid.color.uiColor()
        }
        if !self.strokes.isEmpty,
           let solid = self.strokes[0] as? FSolid,
           let weight = self.strokeWeight {
            if drawModel.fillColor != nil {
                drawModel.strokeColor = (solid.color.uiColor(), weight)
            } else {
                drawModel.fillColor = solid.color.uiColor()
            }
        }
        return drawModel
    }
    
    required init(children: ChildrenDTO, offset: CGPoint) {
        super.init(children: children, offset: offset)
        if let fill = children.fillGeometry,
           fill.count > 0 {
            self.drawing = DrawingCommand.parse(fill[0].path)!
        } else if let stroke = children.strokeGeometry,
                  stroke.count > 0 {
            self.drawing = DrawingCommand.parse(stroke[0].path)!
        }
        if let fills = children.fills {
            self.fills = fills.map { FPaint.initPaint(paint: $0) }
        }
        if let strokes = children.strokes {
            self.strokes = strokes.map { FPaint.initPaint(paint: $0) }
        }
        if let weight = children.strokeWeight {
            self.strokeWeight = weight
        }
    }
    
    override func build() -> FUIView {
        let view = super.build()
        view.content = .drawing(.init(commands: self.drawing, drawModel: self.drawModel))
        return view
    }
}
