import Foundation

public struct BoundingBoxDTO: Decodable {
    public let x: CGFloat
    public let y: CGFloat
    public let width: CGFloat
    public let height: CGFloat
}

public struct ColorDTO: Decodable {
    public let r: CGFloat
    public let g: CGFloat
    public let b: CGFloat
    public let a: CGFloat
}

public struct PaintDTO: Decodable {
    public let visible: Bool?
    public let opacity: CGFloat?
    public let color: ColorDTO?
    public let blendMode: String
    public let type: String
}

public struct Size: Decodable {
    let x: CGFloat
    let y: CGFloat
}

public struct Geometry: Decodable {
    let path: String
}

public struct ChildrenDTO: Decodable {
    public let id: String
    public let name: String
    public let type: String
    public let scrollBehavior: String
    public let fillGeometry: [Geometry]?
    public let strokeGeometry: [Geometry]?
    public let children: [ChildrenDTO]?
    public let absoluteBoundingBox: BoundingBoxDTO?
    public let fills: [PaintDTO]?
    public let backgroundColor: ColorDTO?
    public let cornerRadius: CGFloat?
    public let strokes: [PaintDTO]?
    public let strokeWeight: CGFloat?
    public let blendMode: String?
    public let opacity: CGFloat?
    public let size: Size?
    public let clipsContent: Bool?
}

public struct ComponentDTO: Decodable {
    public let id: String
    public let type: String
    public let scrollBehavior: String
    public let key: String
    public let name: String
    public let description: String
    public let remote: Bool
    public let componentSetId: String
    public let documentationLinks: [String]
}

public struct ComponentSetDTO: Decodable {
    public let key: String
    public let name: String
    public let description: String
    public let remote: Bool
}

public struct StyleDTO: Decodable {
    public let key: String
    public let name: String
    public let styleType: String
    public let remote: Bool
    public let description: String

}

public struct ResponseFDTO: Decodable {
    public let document: ChildrenDTO
    public let components: [String: ComponentDTO]
    public let componentSets: [String: ComponentSetDTO]
    public let schemaVersion: Int
    public let styles: [String: StyleDTO]
}
