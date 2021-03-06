import Foundation

public class Matrix4 {
    var elements: Array<Float>
    
    init() {
        elements = [
            1, 0, 0, 0,
            0, 1, 0, 0,
            0, 0, 1, 0,
            0, 0, 0, 1]
    }

    @discardableResult
    func identity() -> Matrix4 {
        elements = [1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1]
        return self
    }

    @discardableResult
    func copy(_ matrix: Matrix4) -> Matrix4 {
        return setFromArray(matrix.elements)
    }

    func clone() -> Matrix4 {
        return Matrix4().setFromArray(elements)
    }
    
    @discardableResult
    func set(_ n11: Float,_ n12: Float,_ n13: Float,_ n14: Float,
             _ n21: Float,_ n22: Float,_ n23: Float,_ n24: Float,
             _ n31: Float,_ n32: Float,_ n33: Float,_ n34: Float,
             _ n41: Float,_ n42: Float,_ n43: Float,_ n44: Float) -> Matrix4 {
        
        elements[ 0 ] = n11; elements[ 4 ] = n12; elements[ 8 ] = n13; elements[ 12 ] = n14;
        elements[ 1 ] = n21; elements[ 5 ] = n22; elements[ 9 ] = n23; elements[ 13 ] = n24;
        elements[ 2 ] = n31; elements[ 6 ] = n32; elements[ 10 ] = n33; elements[ 14 ] = n34;
        elements[ 3 ] = n41; elements[ 7 ] = n42; elements[ 11 ] = n43; elements[ 15 ] = n44;
        return self
    }

    @discardableResult
    func setFromArray(_ array: Array<Float>,_ offset: Int = 0) -> Matrix4 {
        for i in 0..<16 {
            elements[i] = array[i + offset]
        }
        return self
    }

    @discardableResult
    func setPosition(_ v: Vector3) -> Matrix4 {
        elements[ 12 ] = v.x
        elements[ 13 ] = v.y
        elements[ 14 ] = v.z
        return self
    }

    @discardableResult
    func makePosition(_ v: Vector3) -> Matrix4 {
        return set( 1, 0, 0, v.x, 0, 1, 0, v.y, 0, 0, 1, v.z, 0, 0, 0, 1)
    }

    @discardableResult
    func makeRotationFromQuaternion(_ q: Quaternion ) -> Matrix4 {

        let x = q.x, y = q.y, z = q.z, w = q.w
        let x2 = x + x, y2 = y + y, z2 = z + z
        let xx = x * x2, xy = x * y2, xz = x * z2
        let yy = y * y2, yz = y * z2, zz = z * z2
        let wx = w * x2, wy = w * y2, wz = w * z2

        elements[ 0 ] = 1 - ( yy + zz )
        elements[ 4 ] = xy - wz
        elements[ 8 ] = xz + wy

        elements[ 1 ] = xy + wz
        elements[ 5 ] = 1 - ( xx + zz )
        elements[ 9 ] = yz - wx

        elements[ 2 ] = xz - wy
        elements[ 6 ] = yz + wx
        elements[ 10 ] = 1 - ( xx + yy )

        // last column
        elements[ 3 ] = 0
        elements[ 7 ] = 0
        elements[ 11 ] = 0

        // bottom row
        elements[ 12 ] = 0
        elements[ 13 ] = 0
        elements[ 14 ] = 0
        elements[ 15 ] = 1
        return self
    }

    @discardableResult
    func transpose() -> Matrix4 {
        var tmp = elements[ 1 ]; elements[ 1 ] = elements[ 4 ]; elements[ 4 ] = tmp;
        tmp = elements[ 2 ]; elements[ 2 ] = elements[ 8 ]; elements[ 8 ] = tmp;
        tmp = elements[ 6 ]; elements[ 6 ] = elements[ 9 ]; elements[ 9 ] = tmp;
        tmp = elements[ 3 ]; elements[ 3 ] = elements[ 12 ]; elements[ 12 ] = tmp;
        tmp = elements[ 7 ]; elements[ 7 ] = elements[ 13 ]; elements[ 13 ] = tmp;
        tmp = elements[ 11 ]; elements[ 11 ] = elements[ 14 ]; elements[ 14 ] = tmp;
        return self
    }

    @discardableResult
    func lookAt(origin: Vector3, target: Vector3, up: Vector3) -> Matrix4 {
        let x = Vector3()
        let y = Vector3()
        let z = Vector3()

        z.copy(origin).sub(target)
        if z.mag() == 0 {
            z.z = 1
        }

        z.normalize()
        x.crossVectors(up, z)
        if MathUtil.equals(x.mag(), 0.0) {
            if MathUtil.equals(abs(up.z), 1.0) {
                z.x += 0.0001
            } else {
                z.z += 0.0001
            }
            z.normalize()
            x.crossVectors(up, z)
        }

        x.normalize()
        y.crossVectors(z, x)

        elements[ 0] = x.x; elements[ 4] = y.x; elements[ 8] = z.x
        elements[ 1] = x.y; elements[ 5] = y.y; elements[ 9] = z.y
        elements[ 2] = x.z; elements[ 6] = y.z; elements[10] = z.z
        
        return self
    }

    @discardableResult
    func getInverse(matrix: Matrix4) -> Matrix4 {

        // based on http://www.euclideanspace.com/maths/algebra/matrix/functions/inverse/fourD/index.htm
        let me = matrix.elements,

        n11 = me[ 0 ], n21 = me[ 1 ], n31 = me[ 2 ], n41 = me[ 3 ],
        n12 = me[ 4 ], n22 = me[ 5 ], n32 = me[ 6 ], n42 = me[ 7 ],
        n13 = me[ 8 ], n23 = me[ 9 ], n33 = me[ 10 ], n43 = me[ 11 ],
        n14 = me[ 12 ], n24 = me[ 13 ], n34 = me[ 14 ], n44 = me[ 15 ],

        t11 = n23*n34*n42 - n24*n33*n42 + n24*n32*n43 - n22*n34*n43 - n23*n32*n44 + n22*n33*n44,
        t12 = n14*n33*n42 - n13*n34*n42 - n14*n32*n43 + n12*n34*n43 + n13*n32*n44 - n12*n33*n44,
        t13 = n13*n24*n42 - n14*n23*n42 + n14*n22*n43 - n12*n24*n43 - n13*n22*n44 + n12*n23*n44,
        t14 = n14*n23*n32 - n13*n24*n32 - n14*n22*n33 + n12*n24*n33 + n13*n22*n34 - n12*n23*n34

        let det = n11*t11 + n21*t12 + n31*t13 + n41*t14
        if MathUtil.equals(det, 0.0) {
            return identity()
        }

        let detInv = 1 / det

        elements[ 0 ] = t11*detInv
        elements[ 1 ] = ( n24*n33*n41 - n23*n34*n41 - n24*n31*n43 + n21*n34*n43 + n23*n31*n44 - n21*n33*n44 )*detInv
        elements[ 2 ] = ( n22*n34*n41 - n24*n32*n41 + n24*n31*n42 - n21*n34*n42 - n22*n31*n44 + n21*n32*n44 )*detInv
        elements[ 3 ] = ( n23*n32*n41 - n22*n33*n41 - n23*n31*n42 + n21*n33*n42 + n22*n31*n43 - n21*n32*n43 )*detInv

        elements[ 4 ] = t12*detInv
        elements[ 5 ] = ( n13*n34*n41 - n14*n33*n41 + n14*n31*n43 - n11*n34*n43 - n13*n31*n44 + n11*n33*n44 )*detInv
        elements[ 6 ] = ( n14*n32*n41 - n12*n34*n41 - n14*n31*n42 + n11*n34*n42 + n12*n31*n44 - n11*n32*n44 )*detInv
        elements[ 7 ] = ( n12*n33*n41 - n13*n32*n41 + n13*n31*n42 - n11*n33*n42 - n12*n31*n43 + n11*n32*n43 )*detInv

        elements[ 8 ] = t13*detInv
        elements[ 9 ] = ( n14*n23*n41 - n13*n24*n41 - n14*n21*n43 + n11*n24*n43 + n13*n21*n44 - n11*n23*n44 )*detInv
        elements[ 10 ] = ( n12*n24*n41 - n14*n22*n41 + n14*n21*n42 - n11*n24*n42 - n12*n21*n44 + n11*n22*n44 )*detInv
        elements[ 11 ] = ( n13*n22*n41 - n12*n23*n41 - n13*n21*n42 + n11*n23*n42 + n12*n21*n43 - n11*n22*n43 )*detInv

        elements[ 12 ] = t14*detInv
        elements[ 13 ] = ( n13*n24*n31 - n14*n23*n31 + n14*n21*n33 - n11*n24*n33 - n13*n21*n34 + n11*n23*n34 )*detInv
        elements[ 14 ] = ( n14*n22*n31 - n12*n24*n31 - n14*n21*n32 + n11*n24*n32 + n12*n21*n34 - n11*n22*n34 )*detInv
        elements[ 15 ] = ( n12*n23*n31 - n13*n22*n31 + n13*n21*n32 - n11*n23*n32 - n12*n21*n33 + n11*n22*n33 )*detInv

        return self
    }

    @discardableResult
    func makePerspective(fov: Float, aspect: Float, near: Float, far: Float) -> Matrix4 {
        identity()
        let top = near * tan(MathUtil.DegreeToRadian * 0.5 * fov)
        let bottom = -top
        let left = top * aspect
        let right = -left

        let x = 2 * near / (right - left)
        let y = 2 * near / (top - bottom)

        let a = (right + left) / (right - left)
        let b = (top + bottom) / (top - bottom)
        let c = -(far + near) / (far - near)
        let d = -2 * far * near / (far - near)

        elements[ 0] = x; elements[ 4] = 0; elements[ 8] = a; elements[12] = 0
        elements[ 1] = 0; elements[ 5] = y; elements[ 9] = b; elements[13] = 0
        elements[ 2] = 0; elements[ 6] = 0; elements[10] = c; elements[14] = d
        elements[ 3] = 0; elements[ 7] = 0; elements[11] = -1; elements[15] = 0

        return self
    }

    @discardableResult
    func multiplyMatrices(_ a: Matrix4,_ b: Matrix4) -> Matrix4 {

        let ae = a.elements
        let be = b.elements

        let a11 = ae[ 0], a12 = ae[ 4], a13 = ae[ 8], a14 = ae[12]
        let a21 = ae[ 1], a22 = ae[ 5], a23 = ae[ 9], a24 = ae[13]
        let a31 = ae[ 2], a32 = ae[ 6], a33 = ae[10], a34 = ae[14]
        let a41 = ae[ 3], a42 = ae[ 7], a43 = ae[11], a44 = ae[15]

        let b11 = be[ 0], b12 = be[ 4], b13 = be[ 8], b14 = be[12]
        let b21 = be[ 1], b22 = be[ 5], b23 = be[ 9], b24 = be[13]
        let b31 = be[ 2], b32 = be[ 6], b33 = be[10], b34 = be[14]
        let b41 = be[ 3], b42 = be[ 7], b43 = be[11], b44 = be[15]

        elements[ 0] = a11 * b11 + a12 * b21 + a13 * b31 + a14 * b41
        elements[ 4] = a11 * b12 + a12 * b22 + a13 * b32 + a14 * b42
        elements[ 8] = a11 * b13 + a12 * b23 + a13 * b33 + a14 * b43
        elements[12] = a11 * b14 + a12 * b24 + a13 * b34 + a14 * b44

        elements[ 1] = a21 * b11 + a22 * b21 + a23 * b31 + a24 * b41
        elements[ 5] = a21 * b12 + a22 * b22 + a23 * b32 + a24 * b42
        elements[ 9] = a21 * b13 + a22 * b23 + a23 * b33 + a24 * b43
        elements[13] = a21 * b14 + a22 * b24 + a23 * b34 + a24 * b44

        elements[ 2] = a31 * b11 + a32 * b21 + a33 * b31 + a34 * b41
        elements[ 6] = a31 * b12 + a32 * b22 + a33 * b32 + a34 * b42
        elements[10] = a31 * b13 + a32 * b23 + a33 * b33 + a34 * b43
        elements[14] = a31 * b14 + a32 * b24 + a33 * b34 + a34 * b44

        elements[ 3] = a41 * b11 + a42 * b21 + a43 * b31 + a44 * b41
        elements[ 7] = a41 * b12 + a42 * b22 + a43 * b32 + a44 * b42
        elements[11] = a41 * b13 + a42 * b23 + a43 * b33 + a44 * b43
        elements[15] = a41 * b14 + a42 * b24 + a43 * b34 + a44 * b44

        return self

    }

    @discardableResult
    func compose(_ position: Vector3,_ quaternion: Quaternion,_ scaleVal: Vector3) -> Matrix4 {
        makeRotationFromQuaternion(quaternion)
        scale(scaleVal)
        setPosition(position)
        return self
    }

    func multiply(_ m: Matrix4) -> Matrix4 {
        return multiplyMatrices(self, m)
    }

    @discardableResult
    func scale(_ v: Vector3) -> Matrix4 {
        let x = v.x, y = v.y, z = v.z
        elements[ 0 ] *= x; elements[ 4 ] *= y; elements[ 8 ] *= z
        elements[ 1 ] *= x; elements[ 5 ] *= y; elements[ 9 ] *= z
        elements[ 2 ] *= x; elements[ 6 ] *= y; elements[ 10 ] *= z
        elements[ 3 ] *= x; elements[ 7 ] *= y; elements[ 11 ] *= z
        return self
    }

    func preMultiply(m: Matrix4) -> Matrix4 {
        return multiplyMatrices(m, self)
    }
}
