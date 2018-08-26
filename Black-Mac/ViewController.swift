//
//  ViewController.swift
//  Black-Mac
//
//  Created by AngusLi on 2018/8/25.
//  Copyright © 2018年 com.black. All rights reserved.
//

import Cocoa
import MetalKit

class ViewController: NSViewController {


    @IBOutlet var renderView: RenderView!
    var renderer: Renderer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        renderView.device = MTLCreateSystemDefaultDevice()
        renderer = Renderer(view: renderView)
        renderView.delegate = renderer
        renderView.preferredFramesPerSecond = 60
        renderer?.nodes.append(CubeNode())
    }
    
    override func mouseDown(with event: NSEvent) {
        super.moveDown(event)
        print("mouse down")
    }
}

