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
        case Linear
        case Radial
        case Angular
        case Diamand
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
        case Solid = "SOLID"
        case GradiendLinear = "GRADIENT_LINEAR"
        case GradiendRadial = "GRADIENT_RADIAL"
        case GradiendAngular = "GRADIENT_ANGULAR"
        case GradiendDiamand = "GRADIENT_DIAMOND"
        case Image = "IMAGE"
        case Emoji = "EMOJI"
        case Video = "VIDEO"
    }
    let visible: Bool
    let opacity: CGFloat
    
    static func initPaint(paint: PaintDTO) -> FPaint {
        if let type = FPaintType(rawValue: paint.type) {
            switch type {
            case .Solid:
                return FSolid(paint: paint)
            case .GradiendLinear, .GradiendAngular, .GradiendDiamand, .GradiendRadial:
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
