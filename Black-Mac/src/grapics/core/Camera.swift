import Foundation

public class Camera: Node {
    var size = Size()
    var viewMatrix = Matrix4()
    var projectionMatrix = Matrix4()
    var viewProjectionMatrix = Matrix4()
}

public protocol CameraProtocol {
    func updateViewMatrix() -> Camera
    func updateProjectionMatrix() -> Camera
    func lookAt(target: Vector3) -> Camera
}
