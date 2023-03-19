//
//  FVector.swift
//  FigmaProject
//
//  Created by Roman Gorbenko on 17/03/23.
//

import Foundation
import UIKit

enum DrawingCommand {
    case move(CGPoint)
    case curve(CGPoint, CGPoint, CGPoint)
    case line(CGPoint)
    case close
    
    static func prepareString(str: String) -> String {
        var array = Array(str)
        var i = 1
        while i < array.count {
            if array[i].isLetter {
                array.insert(" ", at: i)
                i += 1
            }
            if array[i - 1].isLetter {
                array.insert(" ", at: i)
                i += 1
            }
            i += 1
        }
        return String(array)
    }
    
    static func parse(_ string: String) -> [DrawingCommand]? {
        let string = prepareString(str: string)
        let commands = string.components(separatedBy: CharacterSet(charactersIn: " ,"))
        var index = 0
        var points = [CGPoint]()
        var result = [DrawingCommand]()
        
        while index < commands.count {
            let command = commands[index]
            switch command {
            case "M":
                index += 1
                if let point = parsePoint(commands, index: &index) {
                    result.append(.move(point))
                    points.append(point)
                } else {
                    fatalError()
                }
            case "C":
                index += 1
                if let fControl = parsePoint(commands, index: &index) {
                    if let sControl = parsePoint(commands, index: &index) {
                        if let endPoint = parsePoint(commands, index: &index) {
                            result.append(.curve(fControl, sControl, endPoint))
                        }
                    }
                } else {
                    fatalError()
                }
            case "L":
                index += 1
                if let point = parsePoint(commands, index: &index) {
                    result.append(.line(point))
                    points.append(point)
                } else {
                    fatalError()
                }
            case "Z":
                index += 1
                result.append(.close)
            default:
                fatalError()
            }
        }
        return result
    }
    
    private static func parsePoint(_ commands: [String], index: inout Int) -> CGPoint? {
        guard index + 1 < commands.count else {
            return nil
        }
        if let x = Double(commands[index]), let y = Double(commands[index + 1]) {
            index += 2
            return CGPoint(x: x, y: y)
        } else {
            return nil
        }
    }
}

class FVector: FView {
    var drawing: [DrawingCommand] = []
    var size: CGSize = .zero
    var fills: [FPaint] = []
    var strokes: [FPaint] = []
    var strokeWeight: CGFloat? = nil
    
    required init(children: ChildrenDTO, offset: CGPoint) {
        super.init(children: children, offset: offset)
        if let fill = children.fillGeometry,
           fill.count > 0 {
            self.drawing = DrawingCommand.parse(fill[0].path)!
        } else if let stroke = children.strokeGeometry,
                  stroke.count > 0 {
            self.drawing = DrawingCommand.parse(stroke[0].path)!
        } else {
            fatalError()
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
        self.size = CGSize(width: children.size!.x, height: children.size!.y)
    }
    
    struct DrawModel {
        var fillColor: UIColor? = nil
        var strokeColor: (UIColor, CGFloat)? = nil
    }
    
    override func build() -> FUIView {
        let view = super.build()
        let imageView = UIImageView()
        var drawModel = DrawModel()
        if !self.fills.isEmpty,
           let solid = self.fills[0] as? FSolid {
            drawModel.fillColor = solid.color.uiColor()
        }
        if !self.strokes.isEmpty,
           let solid = self.strokes[0] as? FSolid,
           let weight = self.strokeWeight
        {
            drawModel.strokeColor = (solid.color.uiColor(), weight)
        }
        imageView.image = drawImage(with: self.drawing, size: self.size, drawModel: drawModel)
        view.addSubview(imageView)
//        view.drawClosure = { [weak self] in
//            guard let self = self else { return }
//            self.draw(with: self.drawing, size: self.size, drawModel: drawModel)
//        }
        imageView.frame = view.bounds
        return view
    }
    
    func draw(with commands: [DrawingCommand], size: CGSize, scale: CGFloat = UIScreen.main.scale, drawModel: DrawModel) {
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        context.setLineCap(.round)
        context.setLineJoin(.round)
        for command in commands {
            switch command {
            case .move(let point):
                context.move(to: point)
            case .curve(let controlPoint1, let controlPoint2, let endPoint):
                context.addCurve(to: endPoint, control1: controlPoint1, control2: controlPoint2)
            case .line(let point):
                context.addLine(to: point)
            case .close:
                context.closePath()
            }
        }
        if let fillColor = drawModel.fillColor {
            context.setFillColor(fillColor.cgColor)
            context.fillPath()
        }
        if let strokeColor = drawModel.strokeColor {
            context.setLineWidth(strokeColor.1/scale)
            context.setStrokeColor(strokeColor.0.cgColor)
            context.strokePath()
        }
    }

    func drawImage(with commands: [DrawingCommand], size: CGSize, scale: CGFloat = UIScreen.main.scale, drawModel: DrawModel) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        context.setLineCap(.round)
        context.setLineJoin(.round)
        for command in commands {
            switch command {
            case .move(let point):
                context.move(to: point)
            case .curve(let controlPoint1, let controlPoint2, let endPoint):
                context.addCurve(to: endPoint, control1: controlPoint1, control2: controlPoint2)
            case .line(let point):
                context.addLine(to: point)
            case .close:
                context.closePath()
            }
        }
        if let fillColor = drawModel.fillColor {
            context.setFillColor(fillColor.cgColor)
            context.fillPath()
        }
        if let strokeColor = drawModel.strokeColor {
            context.setLineWidth(strokeColor.1/scale)
            context.setStrokeColor(strokeColor.0.cgColor)
            context.strokePath()
        }
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
