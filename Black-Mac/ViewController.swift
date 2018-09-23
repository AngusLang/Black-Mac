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

        
        
        let standardPass = StandardPass(renderer: renderer!)
        renderer?.passes.append(standardPass)
        
        let plane = PlaneNode()
        plane.scale.set(10, 1, 10)
        plane.material?.color.set(0.97, 0.98, 0.99)
        plane.position.y = -1
        standardPass.addRenderNode(plane)
        
        let loader = OBJLoader()
        let monkeyURI = Bundle.main.path(forResource: "monkey", ofType: "obj")
        let geo = loader.load(url: monkeyURI!)
        let materialMap = Bundle.main.path(forResource: "matcap", ofType: "png")
        let mat = Material()
        mat.map = materialMap
        let monkey = RenderNode(geometry: geo, material: mat)
        monkey.position.x = 1.5
        standardPass.addRenderNode(monkey)
        
        let sphereURI = Bundle.main.path(forResource: "sphere", ofType: "obj")
        let sphereGeo = loader.load(url: sphereURI!)
        let sphereMapURI = Bundle.main.path(forResource: "matcap", ofType: "png")
        let sphereMaterial = Material()
        sphereMaterial.map = sphereMapURI
        let sphere = RenderNode(geometry: sphereGeo, material: sphereMaterial)
        sphere.position.x = -1.5
        standardPass.addRenderNode(sphere)
    }

}

