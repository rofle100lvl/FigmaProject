//
//  FCanvas.swift
//  FigmaProject
//
//  Created by Roman Gorbenko on 17/03/23.
//

import Foundation
import UIKit

class FCanvas: FDocument {
    let backgroundColor: FColor
    
    required init(children: ChildrenDTO, offset: CGPoint) {
        if let color = children.backgroundColor {
            self.backgroundColor = FColor(colorDTO: color)
        } else {
            fatalError()
        }
        super.init(children: children, offset: offset)
    }
    
    override func build() -> FUIView {
        let view = super.build()
        view.backgroundColor = backgroundColor.uiColor()
        return view
    }
}
