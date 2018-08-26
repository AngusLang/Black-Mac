//
//  GLTFLoader.swift
//  Black-Mac
//
//  Created by AngusLi on 2018/8/26.
//  Copyright © 2018年 com.black. All rights reserved.
//
import Foundation

typealias JSON = [String: Any]

public class GLTFLoader {
    
    var _cache: Bool = false
    var cache: Bool {
        set { _cache = newValue }
        get { return _cache }
    }
    
    var cacheMap: NSDictionary = NSDictionary()

    @discardableResult
    static func load(url: URL) -> Node {
        let root = Node()
        var buffers: [Data]
        var views: [GLTFBufferView]
        var accessors: [GLTFAccesssor]
        
        let jsonStr = try! String.init(contentsOf: url)
        let data = try! JSONSerialization.jsonObject(with: jsonStr.data(using: .utf8)!, options: []) as! JSON
        
        // process buffer
        buffers = GLTFBuffer.Parse(data: data["buffers"] as! [JSON])
        views = GLTFBufferView.Parse(data: data["bufferViews"] as! [JSON], buffers: buffers)
        accessors = GLTFAccesssor.Parse(data: data["accessors"] as! [JSON], views: views)
        print(views, accessors)
        return root
    }
}
