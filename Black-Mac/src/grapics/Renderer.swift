import Foundation
import MetalKit

class Renderer: NSObject, MTKViewDelegate {
    
    let view: RenderView!
    let device: MTLDevice!
    let cmdQueue: MTLCommandQueue!

    var size: double2!
    var pixelRatio: Double = 2.0
    
    var colorFormat: MTLPixelFormat!
    var depthFormat: MTLPixelFormat!
    var stencilFormat: MTLPixelFormat!

    var camera: PerspectiveCamera!
    var controller: Controller!
    
    var projectionMatrixBuffer: MTLBuffer?
    var fragmentUniformBuffer: MTLBuffer?
    
    var passes: [Pass] = []
    
    init(view: RenderView)  {
        self.view = view
        view.depthStencilPixelFormat = .depth32Float_stencil8
        device = view.device
        
        colorFormat = view.colorPixelFormat
        depthFormat = view.depthStencilPixelFormat
        stencilFormat = view.depthStencilPixelFormat
        
        cmdQueue = device.makeCommandQueue()
        let screenSize = NSScreen.main?.frame.size
        size = double2(Double(screenSize!.width), Double(screenSize!.height))

        camera = PerspectiveCamera(fov: 90, aspect: Float(size.x / size.y), nz: 0.001, fz: 1000)
        camera.position.set(0, 0, 4)
        camera.size.set(Float(size.x), Float(size.y))

        controller = Controller(camera: camera)
        view.controller = controller
        
        projectionMatrixBuffer = device.makeBuffer(length: MemoryLayout<Matrix4Uniform>.size, options: .storageModeShared)!
        fragmentUniformBuffer = device.makeBuffer(length: MemoryLayout<GlobalFragmentUniform>.size, options: .storageModeShared)!
    }
    
    private func updateUniformBuffer() {
        var ptr = projectionMatrixBuffer?.contents()
        ptr?.copyMemory(from: camera.projectionMatrix.elements, byteCount: MemoryLayout<Matrix4Uniform>.size)
        
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
    
    func draw(in view: MTKView) {
        controller.update()

        updateUniformBuffer()

        let cmd_buff = cmdQueue.makeCommandBuffer()!
        let pass_des = view.currentRenderPassDescriptor
        if pass_des == nil { return }
        pass_des?.colorAttachments[0].clearColor = MTLClearColorMake(0.1, 0.1, 0.1, 1.0);

        let encoder = cmd_buff.makeRenderCommandEncoder(descriptor: pass_des!)
        encoder?.setFrontFacing(MTLWinding.clockwise)
        encoder?.setCullMode(.back)
        encoder?.setVertexBuffer(projectionMatrixBuffer, offset: 0, index: 1)
        encoder?.setFragmentBuffer(fragmentUniformBuffer, offset: 0, index: 0)

        // render passed
        for pass in passes {
            pass.render(encoder: encoder!)
        }

        encoder?.endEncoding()
        cmd_buff.present(view.currentDrawable!)
        cmd_buff.commit()
    }
}
