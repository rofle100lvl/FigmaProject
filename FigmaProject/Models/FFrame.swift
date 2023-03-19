import Foundation
import UIKit

class FFrame: FView {
    let fills: [FPaint]
    let strokes: [FPaint]
    let strokeWeight: CGFloat
    let blendMode: String
    var cornerRadius: CGFloat? = nil
    
    required init(children: ChildrenDTO, offset: CGPoint) {
        if let fillsDTO = children.fills,
           let strokesDTO = children.strokes,
           let strokeWeightDTO = children.strokeWeight,
           let blendModeDTO = children.blendMode {
            self.fills = fillsDTO.map { FPaint.initPaint(paint: $0) }
            self.strokes = strokesDTO.map { FPaint.initPaint(paint: $0) }
            self.strokeWeight = strokeWeightDTO
            self.blendMode = blendModeDTO
        } else {
            fatalError()
        }
        if let cornerRadius = children.cornerRadius {
            self.cornerRadius = cornerRadius
        }
        super.init(children: children, offset: offset)
    }
    
    override func build() -> FUIView {
        let view = super.build()
        if fills.count > 0,
           let solid = self.fills[0] as? FSolid {
            view.backgroundColor = solid.color.uiColor()
        }
        if let cornerRadius = self.cornerRadius {
            view.layer.cornerRadius = cornerRadius
        }
        return view
    }
}
