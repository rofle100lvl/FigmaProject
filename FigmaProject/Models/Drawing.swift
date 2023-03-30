//
//  Drawing.swift
//  FigmaProject
//
//  Created by r.gorbenko on 28.03.2023.
//

import Foundation

struct Drawing {
    var commands: [DrawingCommand]
    var drawModel: DrawModel
}

struct Rotation {
    var rotationAngle: CGFloat
    var relative: [[CGFloat]]
}

struct Text {
    var text: String
    var font: String
    var fontWeight: CGFloat
    var fontSize: CGFloat
    var letterSpacing: CGFloat
    var lineHeightPx: CGFloat
    var lineHeightPercent: CGFloat
}
