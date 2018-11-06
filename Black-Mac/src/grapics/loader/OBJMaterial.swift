//
//  OBJMaterial.swift
//  Black-Mac
//
//  Created by AngusLi on 2018/11/6.
//  Copyright © 2018 com.black. All rights reserved.
//

import Foundation

public struct Color {
    
    public static let Black = Color(r: 0.0, g: 0.0, b: 0.0)
    
    public let r: Float
    public let g: Float
    public let b: Float
}

public enum IlluminationModel: Int {
    case Constant = 0
    case Diffuse = 1
    case DiffuseSpecular = 2
}

class MaterialBlock {
    var name: NSString = ""
    var ambientColor: Color?
    var diffuseColor: Color?
    var specularColor: Color?
    var illuminationModel: IlluminationModel
    var specularExponent: Float?
    var ambientTextureMapFilePath: NSString?
    var diffuseTextureMapFilePath: NSString?
    
    init() {
        illuminationModel = .Constant
    }
}


public final class OBJMaterial {
    
    public let name: NSString
    public let ambientColor: Color?
    public let diffuseColor: Color?
    public let specularColor: Color?
    public let illuminationModel: IlluminationModel
    public let specularExponent: Float?
    public let ambientTextureMapFilePath: NSString?
    public let diffuseTextureMapFilePath: NSString?
    
    init(block: MaterialBlock) {
        name = block.name
        ambientColor = block.ambientColor
        diffuseColor = block.diffuseColor
        specularColor = block.specularColor
        specularExponent = block.specularExponent
        illuminationModel = block.illuminationModel
        ambientTextureMapFilePath = block.ambientTextureMapFilePath
        diffuseTextureMapFilePath = block.diffuseTextureMapFilePath
    }
    
    init(
        name: NSString,
        ambientColor: Color,
        diffuseColor: Color,
        specularColor: Color,
        specularExponent: Float,
        illuminationModel: IlluminationModel,
        ambientTextureMapFilePath: NSString?,
        diffuseTextureMapFilePath: NSString?)
    {
        self.name = name
        self.ambientColor = ambientColor
        self.diffuseColor = diffuseColor
        self.specularColor = specularColor
        self.specularExponent = specularExponent
        self.illuminationModel = illuminationModel
        self.ambientTextureMapFilePath = ambientTextureMapFilePath
        self.diffuseTextureMapFilePath = diffuseTextureMapFilePath
    }
    
}
