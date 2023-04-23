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

class FView: ChildrenDTOAble {
    let id: String
    let name: String
    let scrollBehavior: String
    var visible: Bool? = nil
    var frame: CGRect = .null
    var subviews: [FView] = []
    
    required init(children: ChildrenDTO, offset: CGPoint = .init(x: 0, y: 0)) {
        self.id = children.id
        self.name = children.name
        self.scrollBehavior = children.scrollBehavior
        if let absolutePostition = children.absoluteBoundingBox {
            let absoluteX = absolutePostition.x - offset.x
            let absoluteY = absolutePostition.y - offset.y
            self.frame = CGRect(x: absoluteX, y: absoluteY, width: absolutePostition.width, height: absolutePostition.height)
        }
        else {
            self.frame = .init(x: 0, y: 0, width: 0, height: 0)
        }
        let newOffset = CGPoint(x: frame.minX + offset.x , y: frame.minY + offset.y)
        if let visible = children.visible {
            self.visible = visible
        }
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
                return FVector(children: node, offset: offset)
            case "VECTOR":
                return FVector(children: node, offset: offset)
            case "TEXT":
                return FText(children: node, offset: offset)
            case "LINE":
                return FVector(children: node, offset: offset)
            case "ELLIPSE":
                return FVector(children: node, offset: offset)
            case "REGULAR_POLYGON":
                return FVector(children: node, offset: offset)
            case "STAR":
                return FVector(children: node, offset: offset)
            case "GROUP":
                return FView(children: node, offset: offset)
            case "SECTION":
                return FFrame(children: node, offset: offset)
            case "COMPONENT_SET":
                return FFrame(children: node, offset: offset)
            case "COMPONENT":
                return FFrame(children: node, offset: offset)
            case "INSTANCE":
                return FFrame(children: node, offset: offset)
            case "BOOLEAN_OPERATION":
                return FFrame(children: node, offset: offset)
            default:
                fatalError()
            }
        }
    }
    
    func build() -> FUIView {
        let view = FUIView()
        view.frame = frame
        subviews.forEach { fView in
            view.addSubview(fView.build())
        }
        if let visible = self.visible {
            view.isHidden = !visible
        }
        return view
    }
}
