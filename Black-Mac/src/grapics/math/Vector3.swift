import Foundation

public class Vector3 {
    
    private var _x, _y, _z: Float
    private var elements:[Float] = []
    var updated: Bool = false

    var x: Float {
        set {_x = newValue; updated = true}
        get {return _x}
    }
    var y: Float {
        set {_y = newValue; updated = true}
        get {return _y}
    }
    var z: Float {
        set {_z = newValue; updated = true}
        get {return _z}
    }
    
    init() {
        _x = 0; _y = 0; _z = 0
    }
    
    init(_ x: Float, _ y: Float, _ z: Float) {
        _x = x; _y = y; _z = z;
    }
    
    init(v: Vector3) {
        _x = v.x
        _y = v.y
        _z = v.z
    }
    
    @discardableResult
    func set(_ x: Float,_ y: Float,_ z: Float) -> Vector3 {
        self.x = x
        self.y = y
        self.z = z
        return self
    }
    
    @discardableResult
    func copy(_ v: Vector3) -> Vector3 {
        x = v.x
        y = v.y
        z = v.z
        return self
    }
    
    func clone() -> Vector3 {
        return Vector3(x, y,z)
    }
    
    @discardableResult
    func add(_ v: Vector3) -> Vector3 {
        x += v.x
        y += v.y
        z += v.z
        return self
    }
    
    @discardableResult
    func sub(_ v: Vector3) -> Vector3 {
        x -= v.x
        y -= v.y
        z -= v.z
        return self
    }
    
    func mag() -> Float {
        return x * x + y * y + z * z
    }
    
    func length() -> Float {
        return sqrtf(mag())
    }
    
    @discardableResult
    func multiply(_ v: Vector3) -> Vector3 {
        x *= v.x
        y *= v.y
        z *= v.z
        return self
    }
    
    @discardableResult
    func multiplyScalar(_ scalar: Float) -> Vector3 {
        x *= scalar
        y *= scalar
        z *= scalar
        return self
    }
    
    @discardableResult
    func normalize() -> Vector3 {
        let inv_length = 1.0 / length()
        return multiplyScalar(inv_length)
    }
    
    func minElement() -> Float {
        return min(x, y, z)
    }
    
    func maxElement() -> Float {
        return max(x, y, z)
    }
    
    @discardableResult
    func clamp(_ minV: Vector3,_ maxV: Vector3) -> Vector3 {
        x = max(minV.x, min(maxV.x, x))
        y = max(minV.y, min(maxV.y, y))
        z = max(minV.z, min(maxV.z, z))
        return self
    }
    
    func dot(_ v: Vector3) -> Float {
        return x * v.x + y * v.y + z * v.z
    }
    
    @discardableResult
    func crossVectors(_ a: Vector3,_ b: Vector3) -> Vector3 {
        let ax = a.x, ay = a.y, az = a.z
        let bx = b.x, by = b.y, bz = b.z
        x = ay * bz - az * by
        y = az * bx - ax * bz
        z = ax * by - ay * bx
        return self
    }
    
    @discardableResult
    func cross(_ v: Vector3) -> Vector3 {
        return crossVectors(self, v)
    }
    
    @discardableResult
    func setFromQuaternion(_ q: Quaternion) -> Vector3 {
        let xVal = x, yVal = y, zVal = z
        let qx = q.x, qy = q.y, qz = q.z, qw = q.w

        // calculate quat * vector
        let ix = qw * xVal + qy * zVal - qz * yVal
        let iy = qw * yVal + qz * xVal - qx * zVal
        let iz = qw * zVal + qx * yVal - qy * xVal
        let iw = -qx * xVal - qy * yVal - qz * zVal

        // calculate result * inverse quat
        x = ix * qw + iw * -qx + iy * -qz - iz * -qy
        y = iy * qw + iw * -qy + iz * -qx - ix * -qz
        z = iz * qw + iw * -qz + ix * -qy - iy * -qx

        return self
    }
    
    @discardableResult
    func setFromSpherical(_ s: Spherical) -> Vector3 {
        let sinRadius = sin(s.polar) * s.radius
        x = sinRadius * sin(s.azim)
        y = cos(s.polar) * s.radius
        z = sinRadius * cos(s.azim)
        return self
    }
    
    @discardableResult
    func applyMatrix4(_ m: Matrix4) -> Vector3 {
        let xVal = x
        let yVal = y
        let zVal = z
        let e = m.elements
    
        let w = 1 / (e[ 3] * xVal + e[ 7] * yVal + e[11] * zVal + e[15])
        x = (e[ 0] * xVal + e[ 4] * yVal + e[ 8] * zVal + e[12]) * w
        y = (e[ 1] * xVal + e[ 5] * yVal + e[ 9] * zVal + e[13]) * w
        z = (e[ 2] * xVal + e[ 6] * yVal + e[10] * zVal + e[14]) * w

        return self
    }
    
    @discardableResult
    func buffer() -> [Float] {
        elements = [_x, _y, _z]
        return elements
    }

}
