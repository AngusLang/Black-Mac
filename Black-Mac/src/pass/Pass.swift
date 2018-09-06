//
//  Pass.swift
//  Black-Mac
//
//  Created by AngusLi on 2018/9/6.
//  Copyright © 2018年 com.black. All rights reserved.
//

import Foundation
import MetalKit

protocol Pass {
    func render(encoder: MTLRenderCommandEncoder)
}
