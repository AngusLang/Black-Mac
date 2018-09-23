//
//  RenderNode.swift
//  EGS-ios
//
//  Created by AngusLi on 2018/8/20.
//  Copyright © 2018年 qunhequnhe. All rights reserved.
//

import MetalKit

public class RenderNode: Node {
    
    var geometry: Geometry?
    var material: Material?

    var viewModelMatrixUniform: MTLBuffer?
    var normalMatrixUniform: MTLBuffer?
    var bufferNeedUpdate: Bool = true

    init(geometry: Geometry, material: Material) {
        self.geometry = geometry
        self.material = material
        super.init()
    }
    
    func createBuffer(device: MTLDevice) {
        bufferNeedUpdate = false
        
        let matrix4ByteSize = MemoryLayout<Matrix4Uniform>.size
        
        viewModelMatrixUniform = device.makeBuffer(length: matrix4ByteSize, options: .storageModeShared)!
        normalMatrixUniform = device.makeBuffer(length: matrix4ByteSize, options: .storageModeShared)!
        
        geometry?.createBuffer(device: device)
        material?.createBuffer(device: device)
    }
    
}
