//
//  FPaint.swift
//  FigmaProject
//
//  Created by Roman Gorbenko on 17/03/23.
//

import Foundation

class FSolid: FPaint {
    let color: FColor
    
    required init(paint: PaintDTO) {
        self.color = FColor(colorDTO: paint.color!)
        super.init(paint: paint)
    }
}

class FGradient: FPaint {
    enum GradientType {
        case linear
        case radial
        case angular
        case diamand
    }
    
    struct ColorStop {
        let number: Int
        let color: FColor
    }
    
    required init(paint: PaintDTO) {
        self.blendNode = paint.blendMode
        self.gradientHandlePositions = []
        self.gradientStops = []
        super.init(paint: paint)
    }
    
    let blendNode: String
    let gradientHandlePositions: [CGSize]
    let gradientStops: [ColorStop]
}


class FPaint: PaintDTOAble {
    required init(paint: PaintDTO) {
        self.visible = paint.visible ?? true
        self.opacity = paint.opacity ?? 1
    }
    
    enum FPaintType: String {
        case solid = "SOLID"
        case gradiendLinear = "GRADIENT_LINEAR"
        case gradiendRadial = "GRADIENT_RADIAL"
        case gradiendAngular = "GRADIENT_ANGULAR"
        case gradiendDiamand = "GRADIENT_DIAMOND"
        case image = "IMAGE"
        case emoji = "EMOJI"
        case video = "VIDEO"
    }
    let visible: Bool
    let opacity: CGFloat
    
    static func initPaint(paint: PaintDTO) -> FPaint {
        if let type = FPaintType(rawValue: paint.type) {
            switch type {
            case .solid:
                return FSolid(paint: paint)
            case .gradiendLinear, .gradiendAngular, .gradiendDiamand, .gradiendRadial:
                return FGradient(paint: paint)
            default:
                return FPaint(paint: paint)
            }
        }
        else {
            fatalError()
        }
    }
}
