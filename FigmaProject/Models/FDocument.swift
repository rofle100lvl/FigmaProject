//
//  FDocument.swift
//  FigmaProject
//
//  Created by Roman Gorbenko on 17/03/23.
//

import Foundation
import UIKit

class FDocument: FView {
    required init(children: ChildrenDTO, offset: CGPoint = .init(x: 0, y: 0)) {
        super.init(children: children, offset: offset)
        calculate()
    }
    
    func calculate() {
        var maxHeight: CGFloat = 0
        var maxWidth: CGFloat = 0
        self.subviews.forEach {
            maxHeight = max(maxHeight, $0.frame.height)
            maxWidth = max(maxWidth, $0.frame.width)
        }
        self.frame = UIScreen.main.bounds
    }
}
