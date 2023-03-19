//
//  FRectangle.swift
//  FigmaProject
//
//  Created by Roman Gorbenko on 17/03/23.
//

import Foundation

final class FRectangle: FVector {
    required init(children: ChildrenDTO, offset: CGPoint) {
        super.init(children: children, offset: offset)
    }
}
