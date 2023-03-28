//
//  FUIVIew.swift
//  FigmaProject
//
//  Created by Roman Gorbenko on 19/03/23.
//

import Foundation
import UIKit
import CoreText

class FUIView: UIView {
    var drawClosure: (() -> CGPath?)? = nil
    var commands: [DrawingCommand] = []
    var drawModel: DrawModel? = nil
    var rotationAngle: CGFloat?
    var relative: [[CGFloat]]? = nil
    var text: String?
    var font: String?
    var fontWeight: CGFloat?
    var fontSize: CGFloat?
    var letterSpacing: CGFloat?
    var lineHeightPx: CGFloat?
    var lineHeightPercent: CGFloat?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if !self.commands.isEmpty,
           let drawModel = self.drawModel {
            drawR(drawModel: drawModel)
        } else if let relative = self.relative {
            self.transform = CGAffineTransform(a: relative[0][0], b: relative[1][0], c: relative[0][1], d: relative[1][1], tx: 0, ty: 0)
        }
        if self.text != nil {
            type()
        }
    }
    
    func drawR(scale: CGFloat = UIScreen.main.scale, drawModel: DrawModel) {
        let shapeLayer = CAShapeLayer()
        if let stroke = drawModel.strokeColor {
            shapeLayer.lineWidth = stroke.1 * scale
            shapeLayer.fillColor = stroke.0.cgColor
            shapeLayer.strokeColor = stroke.0.cgColor
        }
        if let fillColor = drawModel.fillColor {
            shapeLayer.fillColor = fillColor.cgColor
        }
        
        let path = UIBezierPath()
        
        for command in commands {
            switch command {
            case .move(let point):
                path.move(to: point)
            case .curve(let controlPoint1, let controlPoint2, let endPoint):
                path.addCurve(to: endPoint, controlPoint1: controlPoint1, controlPoint2: controlPoint2)
            case .line(let point):
                path.addLine(to: point)
            case .close:
                path.close()
            }
        }
        if let relative = self.relative {
            path.apply(CGAffineTransform(a: relative[0][0], b: relative[1][0], c: relative[0][1], d: relative[1][1], tx: 0, ty: 0))
        }
        shapeLayer.path = path.cgPath
        layer.addSublayer(shapeLayer)
        if let relative = self.relative {
            self.frame = .init(x: relative[0][2], y: relative[1][2], width: path.cgPath.boundingBox.width, height: path.cgPath.boundingBox.height)
            shapeLayer.frame = self.bounds
        }
    }
    
    func type() {
        let layer = CenterTextLayer()
        layer.string = self.text
        
        layer.contentsScale = UIScreen.main.scale;
        if var fontName = font,
           let fontSize = fontSize {
            if !UIFont.familyNames.contains(where: { $0 == fontName }) {
                fontName = "Helvetica"
            }
            let uiFont = UIFont(name: fontName, size: fontSize)
            if let font = uiFont {
                let fontName = font.fontName as NSString
                let cgFont = CGFont(fontName)
                layer.font = cgFont
                layer.fontSize = font.pointSize
                let attributes: [NSAttributedString.Key: Any] = [
                    .font: uiFont,
                    .foregroundColor: UIColor.black
                ]
                let str = NSAttributedString(string: text!, attributes: attributes)
                layer.foregroundColor = UIColor.black.cgColor
                layer.frame = CGRect(x: 0, y: 0, width: str.size().width, height: str.size().height)
                self.layer.frame = CGRect(x: relative![0][2], y: relative![1][2], width: str.size().width, height: str.size().height)
            }
        }
        self.layer.addSublayer(layer)
        if let rotationAngle = self.rotationAngle {
            self.layer.anchorPoint = .init(x: 0, y: 0)
            self.layer.setAffineTransform(CGAffineTransform(rotationAngle: rotationAngle))
        }
    }
}
