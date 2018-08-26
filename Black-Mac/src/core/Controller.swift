//
//  Controller.swift
//  Black
//
//  Created by AngusLi on 2018/8/23.
//  Copyright © 2018年 lang. All rights reserved.
//
import MetalKit

let Pi: Float = 3.141592653;
let MaxPolarAngle: Float = 179 / 180 * Pi;
let MinPolarAngle: Float  = 0.1;
let RotateAngleFactor: Float = 2.5;

let v = Vector3()

public class Controller {
    
    var spherical: Spherical = Spherical()
    var center: Vector3 = Vector3()
    let camera: Camera!
    
    init(camera: Camera) {
        self.camera = camera
        v.copy(camera.position).sub(center)
        spherical.setFrom(vector: v)
    }
    
    public func rotate(offset: Vector2) {
        spherical.azim += offset.x / camera.size.width * Pi * RotateAngleFactor;
        spherical.polar = MathUtil.clamp(spherical.polar - offset.y / camera.size.height * Pi * RotateAngleFactor, MinPolarAngle, MaxPolarAngle);
    }
    
    public func move(offset: Vector2) {
        offset.rotate(radians: spherical.azim).multiplyScalar(spherical.radius * 0.002);
        center.x += offset.x;
        center.z -= offset.y;
    }
    
    public func zoom(factor: Float) {
        spherical.radius *= factor
    }
    
    public func update() {
        v.setFromSpherical(spherical).add(center)
        camera.position.copy(v)
        (camera as! PerspectiveCamera).lookAt(target: center)
    }
    
}
