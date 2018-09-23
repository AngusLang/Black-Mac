import Foundation
import simd

struct FaceVertex {
    var vi, ti, ni: Int
}

class OBJLoader {
    
    func load(url: String) -> Geometry {
        let content = try! String(contentsOf: URL(fileURLWithPath: url))
        
        let scanner = Scanner(string: content)
        
        let skipSet = CharacterSet.whitespacesAndNewlines
        let consumeSet = skipSet.inverted
        
        scanner.charactersToBeSkipped = skipSet
        
        var position: [float3] = []
        var normal: [float3] = []
        var tex: [float2] = []
        var face: [FaceVertex] = []
        
        while !scanner.isAtEnd {
            var token: NSString? = nil
            if !scanner.scanCharacters(from: consumeSet, into: &token) {
                break;
            }
            
            if token!.isEqual(to: "v") {
                var x: Float = 0
                var y: Float = 0
                var z: Float = 0
                scanner.scanFloat(&x)
                scanner.scanFloat(&y)
                scanner.scanFloat(&z)
                position.append(float3(x, y, z))
            }
            else if token!.isEqual(to: "vn") {
                var nx: Float = 0
                var ny: Float = 0
                var nz: Float = 0
                scanner.scanFloat(&nx)
                scanner.scanFloat(&ny)
                scanner.scanFloat(&nz)
                normal.append(float3(nx, ny, nz))
            }
            else if token!.isEqual(to: "vt") {
                var u: Float = 0
                var v: Float = 0
                scanner.scanFloat(&u)
                scanner.scanFloat(&v)
                tex.append(float2(u, v))
            }
            else if token!.isEqual(to: "f") {
                var vi: Int = 0
                var ni: Int = 0
                var ti: Int = 0
                while true {
                    if !scanner.scanInt(&vi) {
                        break
                    }
                    
                    if scanner.scanString("/", into: nil) {
                        scanner.scanInt(&ti)
                        
                        if scanner.scanString("/", into: nil) {
                            scanner.scanInt(&ni)
                        }
                    }
                    
                    face.append(FaceVertex(vi: vi, ti: ti, ni: ni))
                }
            }
        }
        
        let geo = Geometry()
        geo.attribute = []
        
        for f in face {
            let v = position[f.vi - 1]
            let n = normal[f.ni - 1]
            let a = Attribute(position: v, normal: n)
            geo.attribute?.append(a)
        }
        
        return geo
    }
}
