//
//  FGroup.swift
//  FigmaProject
//
//  Created by Roman Gorbenko on 17/03/23.
//

import Foundation
import UIKit

class FGroup: FView {
    required init(children: ChildrenDTO, offset: CGPoint) {
        super.init(children: children, offset: offset)
    }
    
    override func build() -> FUIView {
        let view = super.build()
        return view
    }
}
