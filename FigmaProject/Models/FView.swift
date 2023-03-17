//
//  FView.swift
//  FigmaProject
//
//  Created by Roman Gorbenko on 15/03/23.
//

import Foundation
import UIKit

protocol ChildrenDTOAble {
    init(children: ChildrenDTO, offset: CGPoint)
}

public class FView: ChildrenDTOAble {
    let id: String
    let name: String
    let scrollBehavior: String
    var frame: CGRect = .null 
    var subviews: [FView] = []
    
    required public init(children: ChildrenDTO, offset: CGPoint = .init(x: 0, y: 0)) {
        self.id = children.id
        self.name = children.name
        self.scrollBehavior = children.scrollBehavior
        if let absolutePostition = children.absoluteBoundingBox {
            var absoluteX = absolutePostition.x - offset.x
            var absoluteY = absolutePostition.y - offset.y
            self.frame = CGRect(x: absoluteX, y: absoluteY, width: absolutePostition.width, height: absolutePostition.height)
        }
        else {
            self.frame = .init(x: 0, y: 0, width: 0, height: 0)
        }
        let newOffset = CGPoint(x: frame.minX + offset.x , y: frame.minY + offset.y)
        if let nodes = children.children {
            self.subviews = initNext(nodes: nodes, offset: newOffset)
        }
    }
    
    private func initNext(nodes: [ChildrenDTO], offset: CGPoint) -> [FView] {
        nodes.map { node in
            switch node.type {
            case "CANVAS":
                return FCanvas(children: node, offset: offset)
            case "FRAME":
                return FFrame(children: node, offset: offset)
            case "RECTANGLE":
                return FFrame(children: node, offset: offset)
            case "VECTOR":
                return FFrame(children: node, offset: offset)
            case "TEXT":
                return FFrame(children: node, offset: offset)
            case "LINE":
                return FFrame(children: node, offset: offset)
            default:
                fatalError()
            }
        }
    }
    
    public func build() -> UIView {
        let view = UIView()
        view.frame = frame
        subviews.forEach { fView in
            view.addSubview(fView.build())
        }
        return view
    }
}
