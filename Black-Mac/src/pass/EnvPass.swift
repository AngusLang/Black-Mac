//
//  EnvPass.swift
//  Black-Mac
//
//  Created by AngusLi on 2018/9/6.
//  Copyright © 2018年 com.black. All rights reserved.
//

import Foundation
import simd
import MetalKit

struct EnvmapAttribute {
    var position: float2;
    var uv: float2;
}

public class EnvPass: Black, Pass {

    var color: float3?
    var envmap: MTLTexture?
    
    var quaAttributes: [EnvmapAttribute] = [
        EnvmapAttribute(position: [-1, -1], uv: [0, 1]),
        EnvmapAttribute(position: [ 1,  1], uv: [1, 0]),
        EnvmapAttribute(position: [ 1, -1], uv: [1, 1]),
        EnvmapAttribute(position: [-1,  1], uv: [0, 0]),
        EnvmapAttribute(position: [ 1,  1], uv: [1, 0]),
        EnvmapAttribute(position: [-1, -1], uv: [0, 1])]

    var renderer: Renderer!
    var device: MTLDevice!
    var loader: MTKTextureLoader?
    
    var pipelineState: MTLRenderPipelineState!
    var depthStencilState: MTLDepthStencilState!
    
    var vertexBuffer: MTLBuffer?
    
    init(renderer: Renderer) {
        self.renderer = renderer
        self.device = renderer.device
        super.init()
        name = "env_pass"

        let lib = device.makeDefaultLibrary()
        let vert_func = lib?.makeFunction(name: "envmapVertexShader")
        let frag_func = lib?.makeFunction(name: "envmapFragmentShader")
        
        let pipeline_des = MTLRenderPipelineDescriptor()
        pipeline_des.label = name!
        pipeline_des.vertexFunction = vert_func
        pipeline_des.fragmentFunction = frag_func
        pipeline_des.colorAttachments[0].pixelFormat = renderer.colorFormat
        pipeline_des.depthAttachmentPixelFormat = renderer.depthFormat
        pipeline_des.stencilAttachmentPixelFormat = renderer.stencilFormat
        pipelineState = try! device.makeRenderPipelineState(descriptor: pipeline_des)
        
        let depth_stencil_des = MTLDepthStencilDescriptor()
        depth_stencil_des.depthCompareFunction = .always
        depth_stencil_des.isDepthWriteEnabled = false
        depthStencilState = device.makeDepthStencilState(descriptor: depth_stencil_des)
    }
    
    func setColor(R: Float, G: Float, B: Float) {
        color = float3(R, G, B)
    }
    
    func setEnvMap(url: String) {
        if loader == nil { loader = MTKTextureLoader(device: device) }
        envmap = try! loader?.newTexture(URL: URL(fileURLWithPath: url), options: [:])
    }
    
    func render(encoder: MTLRenderCommandEncoder) {
        
        if vertexBuffer == nil {
            vertexBuffer = device.makeBuffer(bytes: quaAttributes, length: MemoryLayout<EnvmapAttribute>.stride * 6, options: .storageModeShared)
        }
        
        encoder.setRenderPipelineState(pipelineState)
        encoder.setDepthStencilState(depthStencilState)
        encoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        encoder.setFragmentTexture(envmap, index: 0)
        encoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 6)

    }
    
}
