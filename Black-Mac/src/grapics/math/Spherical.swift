import Foundation

public class Spherical {
    
    var radius, polar, azim: Float
    
    init() {
        radius = 1
        polar = 0
        azim = 0
    }
    
    init(_ radius: Float,_ polar: Float,_ azim: Float) {
        self.radius = radius
        self.polar = polar
        self.azim = azim
    }
    
    @discardableResult
    func set(_ radius: Float,_ polar: Float,_ azim: Float) -> Spherical {
        self.radius = radius
        self.polar = polar
        self.azim = azim
        return self
    }
    
    @discardableResult
    func copy(_ s: Spherical) -> Spherical {
        return set(s.radius, s.polar, s.azim)
    }
    
    func clone() -> Spherical {
        return Spherical(radius, polar, azim)
    }
    
    @discardableResult
    func setFrom(vector: Vector3) -> Spherical {
        radius = vector.length()
        if MathUtil.equals(radius, 0.0) {
            polar = 0.0
            azim = 0.0
        } else {
            polar = acos(MathUtil.clamp(vector.y / radius, -1, 1))
            azim = atan2f(vector.x, vector.z)
        }
        return self
    }
}
