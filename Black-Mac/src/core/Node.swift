//
//  Node.swift
//  EGS-ios
//
//  Created by AngusLi on 2018/8/17.
//  Copyright © 2018年 qunhequnhe. All rights reserved.
//

import Foundation
import Metal

public class Node {
    var position = Vector3()
    var quaternion = Quaternion()
    var scale = Vector3(1, 1, 1)
    var worldMatrix = Matrix4()
    
    init() {}
    
    @discardableResult
    public func updateWorldMatrix() -> Node {
        worldMatrix.compose(position, quaternion, scale)
        return self
    }
}
