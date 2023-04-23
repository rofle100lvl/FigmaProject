import Foundation
import UIKit

class FFrame: FView {
    private var fills: [FPaint] = []
    private var cornerRadius: CGFloat? = nil
    
    required init(children: ChildrenDTO, offset: CGPoint) {
        if let fillsDTO = children.fills {
            self.fills = fillsDTO.map { FPaint.initPaint(paint: $0) }
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
