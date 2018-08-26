//
//  Geometry.swift
//  EGS-ios
//
//  Created by AngusLi on 2018/8/20.
//  Copyright © 2018年 qunhequnhe. All rights reserved.
//
import MetalKit

public class Geometry: Black {
    
    var attribute: [Attribute]?
    var vertexBuffer: MTLBuffer?
    
    public func createBuffer(device: MTLDevice) {
        guard attribute != nil else { return }
        vertexBuffer = device.makeBuffer(
            bytes: attribute!,
            length: MemoryLayout<Attribute>.stride * attribute!.count,
            options: .storageModeShared)
    }
    
}
