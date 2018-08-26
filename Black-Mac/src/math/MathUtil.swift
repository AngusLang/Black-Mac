class MathUtil {

    static let PI: Float = 3.141592653
    static let E: Float = 2.7182818284
    static let EPSILON: Float = 1e-6
    static let DegreeToRadian: Float = PI / 180.0
    static let RadianToDegree: Float = 180.0 / PI

    static func clamp(_ n: Float,_ minVal: Float,_ maxVal: Float) -> Float {
        return max(min(n, maxVal), minVal)
    }

    static func equals(_ a: Float,_ b: Float) -> Bool {
        return abs(a - b) < MathUtil.EPSILON;
    }
}

