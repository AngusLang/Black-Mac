//
//  VertexIndex.swift
//  Black-Mac
//
//  Created by AngusLi on 2018/11/5.
//  Copyright © 2018 com.black. All rights reserved.
//

import Foundation

public typealias Buffer = [Float]

public class VertexIndex {
    public let vIndex: Int?
    public let nIndex: Int?
    public let tIndex: Int?
    
    init(vIndex: Int?, nIndex: Int?, tIndex: Int?) {
        self.vIndex = vIndex
        self.nIndex = nIndex
        self.tIndex = tIndex
    }
}

extension VertexIndex: Equatable {}

public func ==(lhs: VertexIndex, rhs: VertexIndex) -> Bool {
    return lhs.vIndex == rhs.vIndex &&
        lhs.nIndex == rhs.nIndex &&
        lhs.tIndex == rhs.tIndex
}

public class Shape {
    public let name: String?
    public let vertices: [Buffer]
    public let normals: [Buffer]
    public let textureCoords: [Buffer]
    public let material: OBJMaterial?
    
    public let faces: [[VertexIndex]]
    
    public init(name: String?,
                vertices: [Buffer],
                normals: [Buffer],
                textureCoords: [Buffer],
                material: OBJMaterial?,
                faces: [[VertexIndex]]) {
        self.name = name
        self.vertices = vertices
        self.normals = normals
        self.textureCoords = textureCoords
        self.material = material
        self.faces = faces
    }
    
    public final func dataForVertexIndex(v: VertexIndex) -> (Buffer?, Buffer?, Buffer?) {
        var data: (Buffer?, Buffer?, Buffer?) = (nil, nil, nil)
        
        if let vi = v.vIndex {
            data.0 = vertices[vi]
        }
        
        if let ni = v.nIndex {
            data.1 = normals[ni]
        }
        
        if let ti = v.tIndex {
            data.2 = textureCoords[ti]
        }
        
        return data
    }
    
}
