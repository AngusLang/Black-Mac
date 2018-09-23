//
//  CubeNode.swift
//  Black
//
//  Created by AngusLi on 2018/8/21.
//  Copyright © 2018年 lang. All rights reserved.
//

public class CubeNode: RenderNode {
    
    init() {
        let geo = Geometry()
        geo.attribute = [Attribute(position: [-1.0, -1.0, 0.0], normal: [0, 0, -1]),
                         Attribute(position: [ 0.0,  1.0, 0.0], normal: [0, 0, -1]),
                         Attribute(position: [ 1.0, -1.0, 0.0], normal: [0, 0, -1])]
        let mat = Material()
        super.init(geometry: geo, material: mat)
    }
}
