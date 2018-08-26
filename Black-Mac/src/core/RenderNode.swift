//
//  RenderNode.swift
//  EGS-ios
//
//  Created by AngusLi on 2018/8/20.
//  Copyright © 2018年 qunhequnhe. All rights reserved.
//

import MetalKit

public class RenderNode: Node {
    
    var geometry: Geometry?
    var material: Material?
    
    var normalMatrix: Matrix3?

    init(geometry: Geometry, material: Material) {
        self.geometry = geometry
        self.material = material
        super.init()
    }
    
}
