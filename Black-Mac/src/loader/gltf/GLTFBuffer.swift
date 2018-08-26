//
//  GLTFBuffer.swift
//  Black-Mac
//
//  Created by AngusLi on 2018/8/26.
//  Copyright © 2018年 com.black. All rights reserved.
//

import Foundation

public class GLTFBuffer {
    
    static func Parse(data: [[String: Any]]) -> [Data] {
        var buffers: [Data] = []
        for d in data {
            var base64Str = d["uri"] as! String

            // remove base64 header
            if base64Str.hasPrefix("data:application/octet-stream;base64,") {
                base64Str = base64Str.components(separatedBy: ",").last!
            }

            let buffer = Data(base64Encoded: base64Str)
            buffers.append(buffer!)
        }
        return buffers
    }
    
}
