//
//  GLTFBufferView.swift
//  Black-Mac
//
//  Created by AngusLi on 2018/8/26.
//  Copyright © 2018年 com.black. All rights reserved.
//

import Foundation

public class GLTFBufferView {
    
    var name: String?
    var data: Data?
    var stride: Int?
    
    public static func Parse(data: [[String: Any]], buffers: [Data]) -> [GLTFBufferView] {
        var views: [GLTFBufferView] = []
        for d in data {
            let v = GLTFBufferView()
            let start = d["byteOffset"] as! Int
            let end = d["byteLength"] as! Int + start
            v.data = buffers[d["buffer"] as! Int].subdata(in: start..<end)
            v.stride = d["byteStride"] as? Int
            v.name = d["name"] as? String
            views.append(v)
        }
        return views
    }
    
}
