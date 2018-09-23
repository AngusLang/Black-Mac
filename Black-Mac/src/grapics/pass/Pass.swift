//
//  Pass.swift
//  Black-Mac
//
//  Created by AngusLi on 2018/9/6.
//  Copyright © 2018年 com.black. All rights reserved.
//

import Foundation
import MetalKit

public class Pass: Black {
    
    var renderer: Renderer
    var device: MTLDevice
    var view: RenderView
    
    init(renderer: Renderer) {
        self.renderer = renderer
        device = renderer.device
        view = renderer.view
    }
    
    func render(encoder: MTLRenderCommandEncoder) {}
}
