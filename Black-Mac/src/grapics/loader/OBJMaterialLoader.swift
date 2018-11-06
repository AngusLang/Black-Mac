//
//  OBJMaterialLoader.swift
//  Black-Mac
//
//  Created by AngusLi on 2018/11/6.
//  Copyright © 2018 com.black. All rights reserved.
//

import Foundation

public final class OBJMaterialLoader {
    
    struct State {
        var materialName: NSString?
        var ambientColor: Color?
        var diffuseColor: Color?
        var specularColor: Color?
        var illuminationModel: IlluminationModel = .Constant
        var specularExponent: Float?
        var ambientTextureMapFilePath: NSString?
        var diffuseTextureMapFilePath: NSString?
        
        init() {}
        
        func isDirty() -> Bool {
            if materialName != nil {
                return true
            }
            
            if ambientColor != nil {
                return true
            }
            
            if diffuseColor != nil {
                return true
            }
            
            if specularColor != nil {
                return true
            }
            
            if specularExponent != nil {
                return true
            }
            
            if ambientTextureMapFilePath != nil {
                return true
            }
            
            if diffuseTextureMapFilePath != nil {
                return true
            }
            
            return false
        }
    }
    
    private static let newMaterialMarker: NSString          = "newmtl"
    private static let ambientColorMarker: NSString         = "Ka"
    private static let diffuseColorMarker: NSString         = "Kd"
    private static let specularColorMarker: NSString        = "Ks"
    private static let specularExponentMarker: NSString     = "Ns"
    private static let illmuninationModelMarker: NSString   = "illum"
    private static let ambientTextureMarker: NSString       = "map_Ka"
    private static let diffuseTextureMarker: NSString       = "map_Kd"
    
    private let scanner: MaterialScanner
    private var state: State
    private var basePath: NSString?
    
    
    init(source: String, basePath: NSString) {
        scanner = MaterialScanner(source: source)
        state = State()
        self.basePath = basePath
    }
    
    func resetState() {
        scanner.reset()
        state = State()
    }
    
    func read() -> [OBJMaterial] {
        resetState()
        
        var materials: [OBJMaterial] = []
        
        do {
            while scanner.available {
                let marker = scanner.readMarker()
                
                let m = marker
                if m == nil || m!.length < 0 {
                    scanner.nextLine()
                    continue
                }
                
                if OBJMaterialLoader.isAmbientColor(m!) {
                    state.ambientColor = readColor()
                    continue
                }
                
                if OBJMaterialLoader.isDiffuseColor(m!) {
                    state.diffuseColor = readColor()
                    continue
                }
                
                if OBJMaterialLoader.isSpecularColor(m!) {
                    state.specularColor = readColor()
                    continue
                }
                
                if OBJMaterialLoader.isSpecularExponent(m!) {
                    state.specularExponent = readSpecularExponent()
                    continue
                }
                
                if OBJMaterialLoader.isIllumiantionModel(m!) {
                    state.illuminationModel = readIlluminationModel()
                    continue
                }
                
                if OBJMaterialLoader.isAmbientTextureMap(m!) {
                    let filename = readFilename()
                    state.ambientTextureMapFilePath = basePath!.appendingPathComponent(filename as String) as NSString
                    continue
                }
                
                if OBJMaterialLoader.isDiffuseTextureMap(m!) {
                    let filename = readFilename()
                    state.diffuseTextureMapFilePath = basePath!.appendingPathComponent(filename as String) as NSString
                    continue
                }
                
                if OBJMaterialLoader.isNewMaterial(m!) {
                    let material = buildMaterial()
                    
                    if material != nil {
                        materials.append(material!)
                    }
                    
                    state = State()
                    state.materialName = scanner.readLine()
                    continue
                }
                
                scanner.readLine()
                scanner.nextLine()
                continue
            }
            
            if let material = buildMaterial() {
                materials.append(material)
            }
            
            state = State()
            
        }
        
        return materials
    }
    
    private static func isNewMaterial(_ marker: NSString) -> Bool {
        return marker == newMaterialMarker
    }
    
    private static func isAmbientColor(_ marker: NSString) -> Bool {
        return marker == ambientColorMarker
    }
    
    private static func isDiffuseColor(_ marker: NSString) -> Bool {
        return marker == diffuseColorMarker
    }
    
    private static func isSpecularColor(_ marker: NSString) -> Bool {
        return marker == specularColorMarker
    }
    
    private static func isSpecularExponent(_ marker: NSString) -> Bool {
        return marker == specularExponentMarker
    }
    
    private static func isIllumiantionModel(_ marker: NSString) -> Bool {
        return marker == illmuninationModelMarker
    }
    
    private static func isAmbientTextureMap(_ marker: NSString) -> Bool {
        return marker == ambientTextureMarker
    }
    
    private static func isDiffuseTextureMap(_ marker: NSString) -> Bool {
        return marker == diffuseTextureMarker
    }
    
    private func readColor() -> Color {
        return try! scanner.readColor()
    }
    
    private func readSpecularExponent() -> Float {
        let value = try! scanner.readFloat()
        
        return MathUtil.clamp(value, 0.0, 1000.0)
    }
    
    private func readIlluminationModel() -> IlluminationModel {
        let value = try! scanner.readInt()
        return IlluminationModel(rawValue: Int(value))!
    }
    
    private func readFilename() -> NSString {
        return try! scanner.readString()
    }
    
    private func buildMaterial() -> OBJMaterial? {
        guard state.isDirty() else {
            return nil
        }
        
        guard let name = state.materialName else {
            return nil
        }
        
        return OBJMaterial(name: name,
                           ambientColor: state.ambientColor ?? Color.Black,
                           diffuseColor: state.diffuseColor ?? Color.Black,
                           specularColor: state.specularColor ?? Color.Black,
                           specularExponent: state.specularExponent ?? 0.0,
                           illuminationModel: state.illuminationModel ,
                           ambientTextureMapFilePath: state.ambientTextureMapFilePath,
                           diffuseTextureMapFilePath: state.diffuseTextureMapFilePath)
    }
    
}
