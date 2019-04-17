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
        
        let monkeyURI = Bundle.main.path(forResource: "monkey", ofType: "obj")! as String
        let basePath = (monkeyURI as NSString).deletingLastPathComponent
        let content = try! String.init(contentsOfFile: monkeyURI, encoding: .utf8)
        let loader = OBJLoader(source: content, basePath: basePath as NSString)
        let shapes = try! loader.read()
        print(shapes)
        
//        let loader OBJScannerer()
//
//        let geo = loader.load(url: monkeyURI!)
//        let materialMap = Bundle.main.path(forResource: "skin", ofType: "jpg")
//        let mat = Material()
//        mat.map = materialMap
//        let monkey = RenderNode(geometry: geo, material: mat)
//        standardPass.addRenderNode(monkey)
    }

}

