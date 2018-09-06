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

        let envmapURI = Bundle.main.path(forResource: "envmap", ofType: "jpg")
        let envPass = EnvPass(renderer: renderer!)
        envPass.setEnvMap(url: envmapURI!)
        renderer?.passes.append(envPass)
        
        let loader = OBJLoader()
        let boxURI = Bundle.main.path(forResource: "box", ofType: "obj")
        let geo = loader.load(url: boxURI!)
        let mat = Material()
        renderer?.nodes.append(RenderNode(geometry: geo, material: mat))
    }
    
    override func mouseDown(with event: NSEvent) {
        super.moveDown(event)
        print("mouse down")
    }
}

