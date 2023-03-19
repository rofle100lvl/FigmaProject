import Foundation

struct BoundingBoxDTO: Decodable {
    let x: CGFloat
    let y: CGFloat
    let width: CGFloat
    let height: CGFloat
}

struct ColorDTO: Decodable {
    let r: CGFloat
    let g: CGFloat
    let b: CGFloat
    let a: CGFloat
}

 struct PaintDTO: Decodable {
     let visible: Bool?
     let opacity: CGFloat?
     let color: ColorDTO?
     let blendMode: String
     let type: String
}

 struct ChildrenDTO: Decodable {
     let id: String
     let name: String
     let type: String
     let scrollBehavior: String
     let children: [ChildrenDTO]?
     let absoluteBoundingBox: BoundingBoxDTO?
     let fills: [PaintDTO]?
     let backgroundColor: ColorDTO?
     let cornerRadius: CGFloat?
     let strokes: [PaintDTO]?
     let strokeWeight: CGFloat?
     let blendMode: String?
     let opacity: CGFloat?
     let size: CGSize?
     let clipsContent: Bool?
}

 struct ComponentDTO: Decodable {
     let id: String
     let type: String
     let scrollBehavior: String
     let key: String
     let name: String
     let description: String
     let remote: Bool
     let componentSetId: String
     let documentationLinks: [String]
}

 struct ComponentSetDTO: Decodable {
     let key: String
     let name: String
     let description: String
     let remote: Bool
}

 struct StyleDTO: Decodable {
     let key: String
     let name: String
     let styleType: String
     let remote: Bool
     let description: String

}

 struct FigmaResponseDTO: Decodable {
     let document: ChildrenDTO
     let components: [String: ComponentDTO]
     let componentSets: [String: ComponentSetDTO]
     let schemaVersion: Int
     let styles: [String: StyleDTO]
}
