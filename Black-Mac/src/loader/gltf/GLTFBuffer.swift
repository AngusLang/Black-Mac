//
//  GLTFBuffer.swift
//  Black-Mac
//
//  Created by AngusLi on 2018/8/26.
//  Copyright © 2018年 com.black. All rights reserved.
//

import Foundation

public class GLTFBuffer {
    
    static func process(buffers: [[String: Any]]) -> [Data] {
        var data: [Data] = []
        if buffers.count <= 0 { return data }
        for buffer in buffers {
            let base64Str = buffer["uri"] as! String
            let d = Data.init(base64Encoded: base64Str)
            data.append(d!)
        }
        return data
    }
    
}
