//
//  GLTFNode.swift
//  Black-Mac
//
//  Created by AngusLi on 2018/8/26.
//  Copyright © 2018年 com.black. All rights reserved.
//

import Foundation

public class GLTFNode {
    
    public static func parse(data: [[String: Any]]) -> [Node] {
        var nodes: [Node] = []
        for d in data {
            let n = Node()
            n.name = d["name"] as! String
        }
        return nodes
    }
}
