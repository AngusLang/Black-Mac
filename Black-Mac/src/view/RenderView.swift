//
//  RenderView.swift
//  Black
//
//  Created by AngusLi on 2018/8/23.
//  Copyright © 2018年 lang. All rights reserved.
//

import Foundation
import MetalKit

public class RenderView: MTKView {
    
    var controller: Controller?
    var start: Vector2 = Vector2()
    var offset: Vector2 = Vector2()
    
    public override init(frame frameRect: CGRect, device: MTLDevice?) {
        super.init(frame: frameRect, device: device)
        addTrackingArea(NSTrackingArea.init(rect: bounds, options: .activeAlways, owner: self, userInfo: [:]))
    }

    public required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func pointerDown(with point: NSPoint) {
        start.set(Float(point.x), Float(point.y))
    }
    
    func pointerMove(with point: NSPoint) {
        offset.set(Float(point.x), Float(point.y))
        offset.set(Float(point.x), Float(point.y)).sub(start)
        if controller != nil {
            controller?.rotate(offset: offset)
        }
        start.set(Float(point.x), Float(point.y))
    }
    
    func pointerScroll(with factor: Float) {
        if controller != nil {
            controller?.zoom(factor: factor)
        }
    }
    
    public override func touchesBegan(with event: NSEvent) {
        pointerDown(with: event.locationInWindow)
    }
    
    public override func touchesMoved(with event: NSEvent) {
        pointerMove(with: event.locationInWindow)
    }
    
    public override func mouseDown(with event: NSEvent) {
        pointerDown(with: event.locationInWindow)
    }

    public override func mouseDragged(with event: NSEvent) {
        pointerMove(with: event.locationInWindow)
    }
    
    public override func scrollWheel(with event: NSEvent) {
        pointerScroll(with: event.scrollingDeltaY > 0 ? 1.05 : 0.95)
    }

}
