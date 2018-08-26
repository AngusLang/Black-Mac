//
//  GLTFLoader.swift
//  Black-Mac
//
//  Created by AngusLi on 2018/8/26.
//  Copyright © 2018年 com.black. All rights reserved.
//
import Foundation

public class GLTFLoader {
    
    var _cache: Bool = false
    var cache: Bool {
        set { _cache = newValue }
        get { return _cache }
    }
    
    var cacheMap: NSDictionary = NSDictionary()

    static func load(url: URL) -> Node {
        let root = Node()
        var buffers: [Data]
        
        let jsonStr = try! String.init(contentsOf: url)
        let data = JSONSerialization.jsonObject(with: jsonStr.data(using: .utf8)!, options: []) as! [String: Any?]
        buffer = GLTFBuffer.process(buffers: data["buffers"] as! [[String: Any]])

        return root
    }
}
