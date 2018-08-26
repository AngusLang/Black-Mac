//
//  GLTFAccessor.swift
//  Black-Mac
//
//  Created by AngusLi on 2018/8/26.
//  Copyright © 2018年 com.black. All rights reserved.
//

import Foundation


//5120 (BYTE)    1
//5121(UNSIGNED_BYTE)    1
//5122 (SHORT)    2
//5123 (UNSIGNED_SHORT)    2
//5125 (UNSIGNED_INT)    4
//5126 (FLOAT)    4
var ComponentLenghtMap = [5120: 1, 5121: 2, 5122: 2, 5123: 2, 5125: 4, 5126: 4]

public class GLTFAccesssor {
    
    var name: String?
    var count: Int?
    var data: Data?
    
    public class func Parse(data: [[String: Any]], views: [GLTFBufferView]) -> [GLTFAccesssor] {
        var accessors: [GLTFAccesssor] = []
        for d in data {
            let a = GLTFAccesssor()
            a.name = d["name"] as? String
            a.count = d["count"] as? Int
            
            let v = views[d["bufferView"] as! Int]
            a.data = v.data
            accessors.append(a)
        }
        return accessors
    }
    
}
