import Foundation
import MetalKit

class Renderer: NSObject, MTKViewDelegate {
    
    let device: MTLDevice!
    let queue: MTLCommandQueue!

    var size: double2!
    var pixelRatio: Double = 2.0
    var pipeLine: MTLRenderPipelineState!
    var depthStencilState: MTLDepthStencilState!

    var camera: PerspectiveCamera!
    var controller: Controller!
    var center = Vector3()
    var nodes: [Node] = []
    
    var vertexUniformBuffer: MTLBuffer?
    var fragmentUniformBuffer: MTLBuffer?
    
    init(view: RenderView)  {
        view.depthStencilPixelFormat = .depth32Float_stencil8
        device = view.device
        queue = device.makeCommandQueue()
        let screenSize = NSScreen.main?.frame.size
        size = double2(Double(screenSize!.width), Double(screenSize!.height))
        
        let lib = device.makeDefaultLibrary()
        
        let vert_func = lib?.makeFunction(name: "vertexShader")
        let frag_func = lib?.makeFunction(name: "fragmentShader")
        
        let pipeline_name = "demo"
        let render_pipe_line_des = MTLRenderPipelineDescriptor()
        render_pipe_line_des.label = pipeline_name
        render_pipe_line_des.vertexFunction = vert_func
        render_pipe_line_des.fragmentFunction = frag_func
        render_pipe_line_des.colorAttachments[0].pixelFormat = view.colorPixelFormat
        render_pipe_line_des.depthAttachmentPixelFormat = view.depthStencilPixelFormat
        render_pipe_line_des.stencilAttachmentPixelFormat = view.depthStencilPixelFormat
        
        let depth_stencil_des = MTLDepthStencilDescriptor()
        depth_stencil_des.depthCompareFunction = .less
        depth_stencil_des.isDepthWriteEnabled = true

        depthStencilState = device.makeDepthStencilState(descriptor: depth_stencil_des)
        pipeLine = try! device.makeRenderPipelineState(descriptor: render_pipe_line_des)

        camera = PerspectiveCamera(fov: 90, aspect: Float(size.x / size.y), nz: 0.001, fz: 1000)
        camera.position.set(0, 0, 2)
        camera.size.set(Float(size.x), Float(size.y))

        controller = Controller(camera: camera)
        view.controller = controller
        
        vertexUniformBuffer = device.makeBuffer(length: MemoryLayout<VertexUniform>.size, options: .storageModeShared)!
        fragmentUniformBuffer = device.makeBuffer(length: MemoryLayout<FragmentUniform>.size, options: .storageModeShared)!
    }
    
    private func updateUniformBuffer() {
        var ptr = vertexUniformBuffer?.contents()
        ptr?.copyMemory(from: camera.viewProjectionMatrix.elements, byteCount: MemoryLayout<Float>.size * 16)
        
        ptr = fragmentUniformBuffer?.contents()
        ptr?.copyMemory(from: camera.position.buffer(), byteCount: MemoryLayout<Float>.size * 3)
    }
    
    private func createBufferWith(bytes: UnsafeRawPointer, lenght: Int) -> MTLBuffer {
        return device.makeBuffer(bytes: bytes, length: lenght, options: MTLResourceOptions.storageModeShared)!
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        self.size.x = Double(size.width)
        self.size.y = Double(size.height)
    }
    
    func drawRenderNode(_ node: Node, encoder: MTLRenderCommandEncoder) {
        guard node is RenderNode else { return }

        let rnode = node as! RenderNode
        let geo = rnode.geometry!
        
        if geo.attribute == nil { return }
        if geo.vertexBuffer == nil {
            geo.createBuffer(device: device)
        }

        encoder.setVertexBuffer(geo.vertexBuffer, offset: 0, index: 0)
        encoder.setVertexBuffer(vertexUniformBuffer, offset: 0, index: 1)
        
        encoder.setFragmentBuffer(fragmentUniformBuffer, offset: 0, index: 0)
        
        encoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: geo.attribute!.count)
    }
    
    func draw(in view: MTKView) {
        guard nodes.count > 0 else { return }
        controller.update()
        
        updateUniformBuffer()
        
        let cmd_buff = queue.makeCommandBuffer()!
        let pass_des = view.currentRenderPassDescriptor
        if pass_des != nil {
            let encoder = cmd_buff.makeRenderCommandEncoder(descriptor: pass_des!)
            encoder?.setRenderPipelineState(pipeLine)
            encoder?.setDepthStencilState(depthStencilState)
            encoder?.setFrontFacing(MTLWinding.clockwise)
            encoder?.setCullMode(.back)

            for node in nodes {
                drawRenderNode(node, encoder: encoder!)
            }
            
            encoder?.endEncoding()
            cmd_buff.present(view.currentDrawable!)
        }
        
        cmd_buff.commit()
    }
}
