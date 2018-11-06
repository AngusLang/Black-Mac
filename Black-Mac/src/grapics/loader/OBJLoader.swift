import Foundation

public final class OBJLoader {
    
    class State {
        var objectName: NSString?
        var vertices: [Buffer] = []
        var normals: [Buffer] = []
        var textureCoords: [Buffer] = []
        var faces: [[VertexIndex]] = []
        var material: OBJMaterial?
    }
    
    private static let commentMarker: NSString          = "#"
    private static let vertexMarker: NSString           = "v"
    private static let normalMarker: NSString           = "vn"
    private static let textureCoordMarker: NSString     = "vt"
    private static let objectMarker: NSString           = "o"
    private static let groupMarker: NSString            = "g"
    private static let faceMarker: NSString             = "f"
    private static let materialLibraryMarker: NSString  = "mtllib"
    private static let useMaterialMarker: NSString      = "usemtl"
    
    private let scanner: OBJScanner
    private let basePath: NSString
    private var materialCache: [NSString: OBJMaterial] = [:]
    
    private var state = State()
    private var vertexCount = 0
    private var normalCount = 0
    private var textureCoordCount = 0

    public init(source: String, basePath: NSString) {
        scanner = OBJScanner(source: source)
        self.basePath = basePath
    }
    
    private func resetState() {
        scanner.reset()
        state = State()
        vertexCount = 0
        normalCount = 0
        textureCoordCount = 0
    }
    
    public func read() throws -> [Shape] {
        var shapes: [Shape] = []
        
        resetState()
        
        do {
            while scanner.available {
                let marker = scanner.readMarker()
                
                let m = marker
                if m == nil || m!.length < 0 {
                    scanner.nextLine()
                    continue
                }
                
                if OBJLoader.isComment(m!) {
                    scanner.nextLine()
                    continue
                }
                
                if OBJLoader.isVertex(m!) {
                    if let v = try readVertex() {
                        state.vertices.append(v)
                    }
                    continue
                }
                
                if OBJLoader.isNormal(m!) {
                    if let n = try readVertex() {
                        state.normals.append(n)
                    }
                    continue
                }
                
                if OBJLoader.isTextureCoord(m!) {
                    if let vt = scanner.readTextureCoord() {
                        state.textureCoords.append(vt)
                    }
                    continue
                }

                if OBJLoader.isObject(m!) {
                    if let s = buildShape() {
                        shapes.append(s)
                    }
                    
                    state = State()
                    state.objectName = scanner.readLine()
                    continue
                }
                
                if OBJLoader.isGroup(m!) {
                    if let s = buildShape() {
                        shapes.append(s)
                    }
                    
                    state = State()
                    state.objectName = try scanner.readString()
                    continue
                }
                
                if OBJLoader.isFace(m!) {
                    if let indices = try scanner.readFace() {
                        state.faces.append(normalizeVertexIndices(unnormalizedIndices: indices))
                    }
                    
                    scanner.nextLine()
                    continue
                }
                
                if OBJLoader.isMaterialLibrary(m!) {
                    let filename = try scanner.readToken()
                    try parseMaterialFiles(filenames: [filename!])
                    scanner.nextLine()
                    continue
                }
                
                if OBJLoader.isUseMaterial(m!) {
                    let materialName = try scanner.readString()
                    
                    guard let material = self.materialCache[materialName] else {
                        throw BlackScannerError.UnreadableData(error: "Material \(materialName) referenced before it was definied")
                    }
                    
                    state.material = material
                    scanner.nextLine()
                    continue
                }
                
                scanner.nextLine()
            }
            
            if let s = buildShape() {
                shapes.append(s)
            }
            state = State()
        } catch let e {
            resetState()
            throw e
        }
        return shapes
    }
    
    private static func isComment(_ marker: NSString) -> Bool {
        return marker == commentMarker
    }
    
    private static func isVertex(_ marker: NSString) -> Bool {
        return marker.length == 1 && marker == vertexMarker
    }
    
    private static func isNormal(_ marker: NSString) -> Bool {
        return marker.length == 2 && marker == normalMarker
    }
    
    private static func isTextureCoord(_ marker: NSString) -> Bool {
        return marker.length == 2 && marker == textureCoordMarker
    }
    
    private static func isObject(_ marker: NSString) -> Bool {
        return marker.length == 1 && marker == objectMarker
    }
    
    private static func isGroup(_ marker: NSString) -> Bool {
        return marker.length == 1 && marker == groupMarker
    }
    
    private static func isFace(_ marker: NSString) -> Bool {
        return marker.length == 1 && marker == faceMarker
    }
    
    private static func isMaterialLibrary(_ marker: NSString) -> Bool {
        return marker == materialLibraryMarker
    }
    
    private static func isUseMaterial(_ marker: NSString) -> Bool {
        return marker == useMaterialMarker
    }
    
    private func readVertex() throws -> [Float]? {
        do {
            return try scanner.readVertex()
        } catch BlackScannerError.UnreadableData(let error) {
            throw BlackScannerError.UnreadableData(error: error)
        }
    }
    
    private static func normalizeIndex(_ index: Int?, count: Int) -> Int? {
        guard let i = index else {
            return nil
        }
        
        if i == 0 {
            return 0
        }
        
        return i - count - 1
    }
    
    private func buildShape() -> Shape? {
        if state.vertices.count == 0 && state.normals.count == 0 && state.textureCoords.count == 0 {
            return nil
        }
        
        
        let result =  Shape(name: (state.objectName as String?), vertices: state.vertices, normals: state.normals, textureCoords: state.textureCoords, material: state.material, faces: state.faces)
        vertexCount += state.vertices.count
        normalCount += state.normals.count
        textureCoordCount += state.textureCoords.count
        
        return result
    }
    
    private func normalizeVertexIndices(unnormalizedIndices: [VertexIndex]) -> [VertexIndex] {
        return unnormalizedIndices.map {
            return VertexIndex(vIndex: OBJLoader.normalizeIndex($0.vIndex, count: vertexCount),
                               nIndex: OBJLoader.normalizeIndex($0.nIndex, count: normalCount),
                               tIndex: OBJLoader.normalizeIndex($0.tIndex, count: textureCoordCount))
        }
    }
    
    private func parseMaterialFiles(filenames: [NSString]) throws {
        for filename in filenames {
            
            let fullPath = basePath.appendingPathComponent(filename as String)

            let fileContents = try! NSString.init(contentsOfFile: fullPath, encoding: String.Encoding.utf8.rawValue)
            
            let loader = OBJMaterialLoader(source: fileContents as String, basePath: basePath)
            
            let materials = loader.read()
            
            for material in materials {
                materialCache[material.name] = material
            }
        }
    }
}
