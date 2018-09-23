//
//  Vector2.swift
//  Black
//
//  Created by AngusLi on 2018/8/23.
//  Copyright © 2018年 lang. All rights reserved.
//
import Foundation

public class Vector2 {
    
    var x: Float
    var y: Float
    
    init() {
        x = 0
        y = 0
    }
    
    init(_ x: Float,_ y: Float) {
        self.x = x
        self.y = y
    }
    
    @discardableResult
    func set(_ x: Float,_ y: Float) -> Vector2 {
        self.x = x
        self.y = y
        return self
    }
    
    @discardableResult
    func copy(_ v: Vector2) -> Vector2 {
        self.x = v.x
        self.y = v.y
        return self
    }
    
    func clone() -> Vector2 {
        return Vector2(x, y)
    }
    
    @discardableResult
    func add(_ v: Vector2) -> Vector2 {
        x += v.x
        y += v.y
        return self
    }
    
    @discardableResult
    func sub(_ v: Vector2) -> Vector2 {
        x -= v.x
        y -= v.y
        return self
    }
    
    @discardableResult
    func multiply(_ v: Vector2) -> Vector2 {
        x *= v.x
        y *= v.y
        return self
    }
    
    @discardableResult
    func multiplyScalar(_ s: Float) -> Vector2 {
        x *= s
        y *= s
        return self
    }
    
    @discardableResult
    func rotate(radians: Float) -> Vector2 {
        let xVal = x
        let yVal = y
        let c = cos(radians)
        let s = sin(radians)
        x = xVal * c - yVal * s
        y = xVal * s + yVal * c
        return self
    }
    
}
