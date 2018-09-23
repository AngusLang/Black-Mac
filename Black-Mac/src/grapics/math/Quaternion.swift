import Foundation

public class Quaternion {
    
    var x, y, z, w: Float
    
    init() {
        x = 0
        y = 0
        z = 0
        w = 1
    }
    
    init(_ x: Float, _ y: Float,_ z: Float,_ w: Float) {
        self.x = x
        self.y = y
        self.z = z
        self.w = w
    }

    @discardableResult
    func set(x: Float, _ y: Float,_ z: Float,_ w: Float) -> Quaternion {
        self.x = x
        self.y = y
        self.z = z
        self.w = w
        return self
    }

    @discardableResult
    func copy(q: Quaternion) -> Quaternion {
        x = q.x
        y = q.y
        z = q.z
        w = q.w
        return self
    }

    func clone() -> Quaternion {
        return Quaternion(x, y, z, w)
    }

    @discardableResult
    func inverse() -> Quaternion {
        x *= -1
        y *= -1
        z *= -1
        return self
    }

    @discardableResult
    func length() -> Float {
        return sqrtf(x * x + y * y + z * z + w * w)
    }
    
    @discardableResult
    func normalize() -> Quaternion {
        var l = length()
        if MathUtil.equals(l, 0.0) {
            x = 0
            y = 0
            z = 0
            w = 1
        } else {
            l = 1.0 / l
            x *= l
            y *= l
            z *= l
            w *= l
        }
        return self
    }

    @discardableResult
    func setFromAxisAngle(axis: Vector3, angle: Float) -> Quaternion {
        let halfAngle = angle / 2
        let s = sin(halfAngle)

        x = axis.x * s
        y = axis.y * s
        z = axis.z * s
        w = cos(halfAngle)
        return self
    }

    @discardableResult
    func setFromUnitVectors(vFrom: Vector3, vTo: Vector3) -> Quaternion {
        let v1 = Vector3()
        var r = vFrom.dot(vTo) + 1
        if r < MathUtil.EPSILON {
            r = 0
            if abs(vFrom.x) > abs(vFrom.z) {
                v1.set(-vFrom.y, vFrom.x, 0)
            } else {
                v1.set(0, -vFrom.z, vFrom.y)
            }
        } else {
            v1.crossVectors(vFrom, vTo)
        }
        x = v1.x
        y = v1.y
        z = v1.z
        w = r
        return normalize()
    }

    @discardableResult
    func setFromRotationMatrix(m: Matrix4) -> Quaternion {
        // http://www.euclideanspace.com/maths/geometry/rotations/conversions/matrixToQuaternion/index.htm
        // assumes the upper 3x3 of m is a pure rotation matrix (i.e, unscaled)

        let te = m.elements
        let m11 = te[0], m12 = te[4], m13 = te[8]
        let m21 = te[1], m22 = te[5], m23 = te[9]
        let m31 = te[2], m32 = te[6], m33 = te[10]
        let trace = m11 + m22 + m33
        var s: Float = 0.0

        if (trace > 0) {
            s = 0.5 / sqrtf(trace + 1.0)
            w = 0.25 / s
            x = (m32 - m23) * s
            y = (m13 - m31) * s
            z = (m21 - m12) * s
        } else if (m11 > m22 && m11 > m33) {
            s = 2.0 * sqrtf(1.0 + m11 - m22 - m33)
            w = (m32 - m23) / s
            x = 0.25 * s
            y = (m12 + m21) / s
            z = (m13 + m31) / s
        } else if (m22 > m33) {
            s = 2.0 * sqrtf(1.0 + m22 - m11 - m33)
            w = (m13 - m31) / s
            x = (m12 + m21) / s
            y = 0.25 * s
            z = (m23 + m32) / s
        } else {
            s = 2.0 * sqrtf(1.0 + m33 - m11 - m22)
            w = (m21 - m12) / s
            x = (m13 + m31) / s
            y = (m23 + m32) / s
            z = 0.25 * s
        }
        return self
    }
}
