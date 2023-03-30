//
//  FUIVIew.swift
//  FigmaProject
//
//  Created by Roman Gorbenko on 19/03/23.
//

import Foundation
import UIKit
import CoreText

enum Content {
    case text(Text)
    case drawing(Drawing)
    case frame((CGSize, CGColor))
    case none
}

class FUIView: UIView {
    var content: Content = .none
    var rotate: Rotation? = nil
    
    override func layoutSubviews() {
        super.layoutSubviews()
        switch content {
        case .text(let text):
            type(text: text)
        case .drawing(let drawing):
            drawR(drawing: drawing)
        case .frame(let size):
            let view = UIView()
            view.layer.frame.size = size.0
            view.layer.anchorPoint = .init(x: 0.5, y: 0.5)

            view.layer.position = .init(x: self.layer.bounds.midX, y: self.layer.bounds.midY)
            view.layer.backgroundColor = size.1
            view.anchorPoint = .init(x: 0.5, y: 0.5)

            if let rotat = rotate {
                let rotate = rotat.relative
                view.transform = (CGAffineTransform(a: rotate[0][0], b: rotate[1][0], c: rotate[0][1], d: rotate[1][1], tx: 0, ty: 0))
            }
            addSubview(view)
            view.layer.opacity = 0
            view.bringSubviewToFront(self)
        case .none:
            break
        }
    }
    
    func drawR(scale: CGFloat = UIScreen.main.scale, drawing: Drawing) {
        let shapeLayer = CAShapeLayer()
        if let stroke = drawing.drawModel.strokeColor {
            shapeLayer.lineWidth = stroke.1
            shapeLayer.fillColor = stroke.0.cgColor
            shapeLayer.strokeColor = stroke.0.cgColor
        }
        if let fillColor = drawing.drawModel.fillColor {
            shapeLayer.fillColor = fillColor.cgColor
        }
        
        let path = UIBezierPath()
        
        for command in drawing.commands {
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
        if let rotate = self.rotate {
            let relative = rotate.relative
            path.apply(CGAffineTransform(a: relative[0][0], b: relative[1][0], c: relative[0][1], d: relative[1][1], tx: 0, ty: 0))
        }
        shapeLayer.path = path.cgPath
        let view = UIView()
        view.layer.addSublayer(shapeLayer)
        if let rotate = self.rotate {
            let relative = rotate.relative
            view.frame = .init(x: relative[0][2], y: relative[1][2], width: path.cgPath.boundingBox.width, height: path.cgPath.boundingBox.height)
            shapeLayer.frame = view.bounds
        }
        self.addSubview(view)
    }
    
    func type(text: Text) {
        let layer = CenterTextLayer()
        layer.string = text.text
        var fontName = text.font
        layer.contentsScale = UIScreen.main.scale;
        if !UIFont.familyNames.contains(where: { $0 == text.font }) {
            fontName = "Helvetica"
        }
        let uiFont = UIFont(name: fontName, size: text.fontSize)
        if let font = uiFont {
            let fontName = font.fontName as NSString
            let cgFont = CGFont(fontName)
            layer.font = cgFont
            layer.fontSize = font.pointSize
            let attributes: [NSAttributedString.Key: Any] = [
                .font: uiFont,
                .foregroundColor: UIColor.black
            ]
            let str = NSAttributedString(string: text.text, attributes: attributes)
            layer.foregroundColor = UIColor.black.cgColor
            layer.frame = CGRect(x: 0, y: 0, width: str.size().width, height: str.size().height)
        }
        self.layer.addSublayer(layer)
    }
    
    func rotate(radian: CGFloat) {
        let bounds: CGRect = self.bounds
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        
        let radians = radian
        var transform: CGAffineTransform = .identity
        transform = transform.translatedBy(x: center.x, y: center.y)
        transform = transform.rotated(by: radians)
        transform = transform.translatedBy(x: -center.x, y: -center.y)
        self.transform = transform
    }
}
