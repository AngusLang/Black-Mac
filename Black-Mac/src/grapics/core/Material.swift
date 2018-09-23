//
//  Material.swift
//  EGS-ios
//
//  Created by AngusLi on 2018/8/20.
//  Copyright © 2018年 qunhequnhe. All rights reserved.
//
import MetalKit

public class Material: Black {
    
    var map: String?
    var mapTexture: MTLTexture?
    var loader: MTKTextureLoader?
    
    var color: Vector3 = Vector3()
    
    var uniform: LocalFragmentUniform?
    var uniformBuffer: MTLBuffer?
    
    public func createBuffer(device: MTLDevice) {
        createTexture(device: device)
        
        if uniformBuffer == nil {
            uniformBuffer = device.makeBuffer(length: MemoryLayout<LocalFragmentUniform>.size, options: .storageModeShared)
        }
        
        if uniform == nil {
            uniform = LocalFragmentUniform(color: [color.x, color.y, color.z])
        }
        
        let ptr = uniformBuffer?.contents()
        ptr?.copyMemory(from: [uniform], byteCount: MemoryLayout<LocalFragmentUniform>.size)
    }
    
    public func createTexture(device: MTLDevice) {
        guard map != nil else { return; }
        if loader == nil { loader = MTKTextureLoader(device: device) }
        mapTexture = try! loader?.newTexture(URL: URL(fileURLWithPath: map!), options: [:])
    }
    
}
