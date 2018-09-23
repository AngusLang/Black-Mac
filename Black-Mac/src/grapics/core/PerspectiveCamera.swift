//
//  PerspectiveCamera.swift
//  EGS-ios
//
//  Created by AngusLi on 2018/8/17.
//  Copyright © 2018年 qunhequnhe. All rights reserved.
//

import Foundation

public class PerspectiveCamera: Camera, CameraProtocol {

    var up = Vector3(0, 1, 0)
    var fov, aspect, nz, fz: Float
    
    init(fov: Float, aspect: Float, nz: Float, fz: Float) {
        self.fov = fov
        self.aspect = aspect
        self.nz = nz
        self.fz = fz
        super.init()

        updateProjectionMatrix()
    }
    
    @discardableResult
    func setSize(width: Float, height: Float) -> PerspectiveCamera {
        size.set(width, height)
        aspect = width / height
        return self
    }
    
    @discardableResult
    public func updateViewMatrix() -> Camera {
        return self
    }

    @discardableResult
    public func updateProjectionMatrix() -> Camera {
        projectionMatrix.makePerspective(fov: fov, aspect: aspect, near: nz, far: fz)
        return self
    }
    
    @discardableResult
    public func lookAt(target: Vector3) -> Camera {
        let matrix = Matrix4()
        matrix.lookAt(origin: position, target: target, up: up)
        quaternion.setFromRotationMatrix(m: matrix)
        updateWorldMatrix()
        viewMatrix.getInverse(matrix: worldMatrix)
        viewProjectionMatrix.multiplyMatrices(projectionMatrix, viewMatrix)
        return self
    }
}
