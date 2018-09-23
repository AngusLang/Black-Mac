
//
//  Standard.swift
//  Black-Mac
//
//  Created by AngusLi on 2018/9/7.
//  Copyright © 2018年 com.black. All rights reserved.
//

import Foundation
import MetalKit

public class StandardPass: Pass {
 
    var pipelineState: MTLRenderPipelineState!
    var depthStencilState: MTLDepthStencilState!
    
    var nodes: [RenderNode] = []
    
    var defaultSampler: MTLSamplerState!
    
    override init(renderer: Renderer) {
        super.init(renderer: renderer)
        
        let lib = device.makeDefaultLibrary()
        let vert_func = lib?.makeFunction(name: "vertexShader")
        let frag_func = lib?.makeFunction(name: "fragmentShader")
        
        let pipeline_name = "standard"
        let render_pipe_line_des = MTLRenderPipelineDescriptor()
        render_pipe_line_des.label = pipeline_name
        render_pipe_line_des.vertexFunction = vert_func
        render_pipe_line_des.fragmentFunction = frag_func
        render_pipe_line_des.colorAttachments[0].pixelFormat = renderer.colorFormat
        render_pipe_line_des.depthAttachmentPixelFormat = renderer.depthFormat
        render_pipe_line_des.stencilAttachmentPixelFormat = renderer.stencilFormat
        pipelineState = try! device.makeRenderPipelineState(descriptor: render_pipe_line_des)
        
        let depth_stencil_des = MTLDepthStencilDescriptor()
        depth_stencil_des.depthCompareFunction = .less
        depth_stencil_des.isDepthWriteEnabled = true
        depthStencilState = device.makeDepthStencilState(descriptor: depth_stencil_des)
        
        let sampler_des = MTLSamplerDescriptor()
        sampler_des.magFilter = .linear
        sampler_des.minFilter = .linear
        defaultSampler = device.makeSamplerState(descriptor: sampler_des)
    }
    
    override func render(encoder: MTLRenderCommandEncoder) {
        encoder.setRenderPipelineState(pipelineState!)
        encoder.setDepthStencilState(depthStencilState!)
        encoder.setFragmentSamplerState(defaultSampler, index: 0)
        for node in nodes { drawRenderNode(node, encoder: encoder) }
    }
    
    func addRenderNode(_ node: RenderNode) {
        nodes.append(node)
    }
    
    private func drawRenderNode(_ node: Node, encoder: MTLRenderCommandEncoder) {
        guard node is RenderNode else { return }
        
        let rnode = node as! RenderNode
        let geo = rnode.geometry!
        
        // set attribute
        if geo.attribute == nil { return }
        if rnode.bufferNeedUpdate {
            rnode.updateWorldMatrix()
            rnode.createBuffer(device: device)
        }
        encoder.setVertexBuffer(geo.vertexBuffer, offset: 0, index: 0)
        
        // set viewModelMatrix
        rnode.updateViewModelMatrix(viewMatrix: renderer.camera.viewMatrix);
        var ptr = rnode.viewModelMatrixUniform?.contents()
        ptr?.copyMemory(from: rnode.viewModelMatrix.elements, byteCount: MemoryLayout<Matrix4Uniform>.size)
        encoder.setVertexBuffer(rnode.viewModelMatrixUniform, offset: 0, index: 2)
        
        // set normalMatrix
        ptr = rnode.normalMatrixUniform?.contents()
        ptr?.copyMemory(from: rnode.normalMatrix.elements, byteCount: MemoryLayout<Matrix4Uniform>.size)
        encoder.setVertexBuffer(rnode.normalMatrixUniform, offset: 0, index: 3)
        
        // set material texture
        encoder.setFragmentTexture(rnode.material?.mapTexture, index: 0)
        encoder.setFragmentBuffer(rnode.material?.uniformBuffer, offset: 0, index: 1)
        
        encoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: geo.attribute!.count)
    }
}
