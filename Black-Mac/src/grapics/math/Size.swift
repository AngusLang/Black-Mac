import Foundation

public class Size {

    var width, height: Float
    
    init() {
        width = 0
        height = 0
    }
    
    init(_ width: Float,_ height: Float) {
        self.width = width
        self.height = height
    }

    @discardableResult
    func set(_ width: Float,_ height: Float) -> Size {
        self.width = width
        self.height = height
        return self
    }
    
    @discardableResult
    func copy(_ size: Size) -> Size {
        width = size.width
        height = size.height
        return self
    }
}
