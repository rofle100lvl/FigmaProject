//
//  FText.swift
//  FigmaProject
//
//  Created by Roman Gorbenko on 24/03/23.
//

import Foundation
import UIKit

class FText: FVector {
    let text: String
    let font: String
    let fontWeight: CGFloat
    let fontSize: CGFloat
    let letterSpacing: CGFloat
    let lineHeightPx: CGFloat
    let lineHeightPercent: CGFloat
    
    required init(children: ChildrenDTO, offset: CGPoint) {
        if let text = children.characters,
           let style = children.style {
            self.text = text
            self.font = style.fontFamily
            self.fontWeight = style.fontWeight
            self.fontSize = style.fontSize
            self.letterSpacing = style.letterSpacing
            self.lineHeightPx = style.lineHeightPx
            self.lineHeightPercent = style.lineHeightPercent
        } else {
            fatalError()
        }
        super.init(children: children, offset: offset)
    }
    
    override func build() -> FUIView {
        let view = super.build()
        view.text = text
        view.font = font
        view.lineHeightPercent = lineHeightPx
        view.lineHeightPx = lineHeightPx
        view.fontWeight = fontWeight
        view.fontSize = fontSize
        return view
    }
}
