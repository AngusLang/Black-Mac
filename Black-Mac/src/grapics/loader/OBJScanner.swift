/**
 * author: angus lee
 */

import Foundation

enum BlackScannerError: Error {
    case UnreadableData(error: String)
    case InvalidValue(error: String)
}

class BlackScanner {
    
    public var scanner: Scanner?
    
    var available: Bool {
        get {
            return false == scanner?.isAtEnd
        }
    }
    
    init(source: String) {
        scanner = Scanner(string: source)
    }
    
    func nextLine() {
        scanner?.scanUpToCharacters(from: CharacterSet.newlines, into: nil)
    }
    
    func readMarker() -> NSString? {
        var marker: NSString?
        scanner?.scanUpToCharacters(from: CharacterSet.whitespaces, into: &marker)
        return marker
    }
    
    func readInt() throws -> Int32 {
        var value: Int32 = 0
        if scanner?.scanInt32(&value) == true {
            return value
        }

        throw BlackScannerError.InvalidValue(error: "Invalud Int value")
    }
    
    @discardableResult
    func readLine() -> NSString? {
        var value: NSString?
        scanner?.scanUpToCharacters(from: CharacterSet.newlines, into: &value)
        return value
    }
    
    func readFloat() throws -> Float {
        var value: Float = 0.0
        if scanner?.scanFloat(&value) == true {
            return value
        }
        
        throw BlackScannerError.InvalidValue(error: "Invalid Float value")
    }
    
    func readString() throws -> NSString {
        var string: NSString?
        
        scanner?.scanUpToCharacters(from: CharacterSet.whitespacesAndNewlines, into: &string)
        
        if string != nil {
            return string!
        }
        
        throw BlackScannerError.InvalidValue(error: "Invalid String value")
    }
    
    func readToken() throws -> NSString? {
        var token: NSString?
        
        scanner!.scanUpToCharacters(from: CharacterSet.whitespacesAndNewlines, into: &token)
                
        return token
    }
    
    func reset() {
        scanner?.scanLocation = 0
    }
}

final class OBJScanner: BlackScanner {
    
    func readFace() throws -> [VertexIndex]? {
        var result: [VertexIndex] = []
        
        while true {
            var v, vn, vt: Int?
            var tmp: Int = -1
            
            guard scanner!.scanInt(&tmp) else {
                break
            }
            v = Int(tmp)
            
            guard scanner!.scanString("/", into: nil) else {
                throw BlackScannerError.UnreadableData(error: "Lack of '/'")
            }
            
            if scanner!.scanInt(&tmp) {
                vt = Int(tmp)
            }
            
            guard scanner!.scanString("/", into: nil) else {
                throw BlackScannerError.UnreadableData(error: "Lack of '/'")
            }
            
            if scanner!.scanInt(&tmp) {
                vn = Int(tmp)
            }
            
            result.append(VertexIndex(vIndex: v, nIndex: vn, tIndex: vt))
        }
        
        return result
    }
    
    func readVertex() throws -> Buffer? {
        var x: Float = 0
        var y: Float = 0
        var z: Float = 0
        
        guard scanner!.scanFloat(&x) else {
            throw BlackScannerError.UnreadableData(error: "bad vertex fotmat")
        }
        
        guard scanner!.scanFloat(&y) else {
            throw BlackScannerError.UnreadableData(error: "bad vertex fotmat")
        }
        
        guard scanner!.scanFloat(&z) else {
            throw BlackScannerError.UnreadableData(error: "bad vertex fotmat")
        }
        
        return [x, y, z]
    }
    
    func readTextureCoord() -> Buffer? {
        var u: Float = 0.0
        var v: Float = 0.0
        
        guard scanner!.scanFloat(&u) else {
            return nil
        }
        
        scanner!.scanFloat(&v)
        
        return [u, v]
    }
}

final class MaterialScanner: BlackScanner {
    
    func readColor() throws -> Color {
        var r: Float = 0.0
        var g: Float = 0.0
        var b: Float = 0.0
        
        guard scanner!.scanFloat(&r) else {
            throw BlackScannerError.UnreadableData(error: "bad color definition")
        }
        
        guard scanner!.scanFloat(&g) else {
            throw BlackScannerError.UnreadableData(error: "bad color definition")
        }
        
        guard scanner!.scanFloat(&b) else {
            throw BlackScannerError.UnreadableData(error: "bad color definition")
        }
        
        if r < 0.0 || r > 1.0 {
            throw BlackScannerError.InvalidValue(error: "color value range error")
        }
        
        if g < 0.0 || g > 1.0 {
            throw BlackScannerError.InvalidValue(error: "color value range error")
        }
        
        if b < 0.0 || b > 1.0 {
            throw BlackScannerError.InvalidValue(error: "color value range error")
        }
        
        return Color(r: r, g: g, b: b)
    }
}
