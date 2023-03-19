//
//  FStuff.swift
//  FigmaProject
//
//  Created by Roman Gorbenko on 17/03/23.
//

import Foundation
import UIKit

protocol PaintDTOAble {
    init(paint: PaintDTO)
}

typealias FTransformation = ((CGFloat, CGFloat, CGFloat), (CGFloat, CGFloat, CGFloat))
typealias FGradientPosition = (CGSize, CGSize, CGSize)

struct FColor {
    let r: CGFloat
    let g: CGFloat
    let b: CGFloat
    let a: CGFloat
    
    init(colorDTO: ColorDTO) {
        self.r = colorDTO.r
        self.g = colorDTO.g
        self.b = colorDTO.b
        self.a = colorDTO.a
    }
    
    func uiColor() -> UIColor {
        UIColor(red: r, green: g, blue: b, alpha: a)
    }
}

enum FBlendMode {
    case passThrough
    case normal
    case darken
    case multiply
    case linearBurn
    case colorBurn
    case lighten
    case screen
    case linearDodge
    case colorDodge
    case overlay
    case softLight
    case hardLight
}
