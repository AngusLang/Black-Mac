
//
//  Plane.swift
//  Black-Mac
//
//  Created by AngusLi on 2018/9/16.
//  Copyright © 2018年 com.black. All rights reserved.
//

import Foundation

public class PlaneNode: RenderNode {

    init() {
        let geo = Geometry()
        geo.attribute = [Attribute(position: [-1.0, 0.0,  1.0], normal: [0, 0, 1]),
                         Attribute(position: [ 1.0, 0.0, -1.0], normal: [0, 0, 1]),
                         Attribute(position: [-1.0, 0.0, -1.0], normal: [0, 0, 1]),
                         Attribute(position: [ 1.0, 0.0, -1.0], normal: [0, 0, 1]),
                         Attribute(position: [-1.0, 0.0,  1.0], normal: [0, 0, 1]),
                         Attribute(position: [ 1.0, 0.0,  1.0], normal: [0, 0, 1])]
        let mat = Material()
        super.init(geometry: geo, material: mat)
    }
}

