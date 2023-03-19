//
//  FUIVIew.swift
//  FigmaProject
//
//  Created by Roman Gorbenko on 19/03/23.
//

import Foundation
import UIKit

class FUIView: UIView {
    var drawClosure: (() -> Void)? = nil
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        if let drawClosure = self.drawClosure {
            drawClosure()
        }
    }
}
