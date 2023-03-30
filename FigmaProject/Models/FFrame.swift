import Foundation
import UIKit

class FFrame: FView {
    private var size: CGSize!
    private var fills: [FPaint] = []
    private var cornerRadius: CGFloat? = nil
    
    required init(children: ChildrenDTO, offset: CGPoint) {
        if let fillsDTO = children.fills {
            self.fills = fillsDTO.map { FPaint.initPaint(paint: $0) }
        }
        if let cornerRadius = children.cornerRadius {
            self.cornerRadius = cornerRadius
        }
        if let size = children.size {
            self.size = CGSize(width: size.x, height: size.y)
        }
        super.init(children: children, offset: offset)
    }
    
    override func build() -> FUIView {
        let view = super.build()
        if fills.count > 0,
           let solid = self.fills[0] as? FSolid {
            let color = solid.color.uiColor().cgColor
            view.content = .frame((self.size, color))
        }
        if let cornerRadius = self.cornerRadius {
            view.layer.cornerRadius = cornerRadius
        }
        return view
    }
}
