//
//  GLTFMesh.swift
//  Black-Mac
//
//  Created by AngusLi on 2018/8/26.
//  Copyright © 2018年 com.black. All rights reserved.
//

import Foundation

public class GLTFMesh {
    
    public static func parse(data: [[String: Any]]) -> [Geometry] {
        var geometrys: [Geometry] = []
        for d in data {
            let g = Geometry()
            g.name = d["name"] as? String
            
            geometrys.append(g)
        }
        return geometrys
    }
}
