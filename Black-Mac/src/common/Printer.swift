//
//  Printer.swift
//  Black-Mac
//
//  Created by AngusLi on 2018/9/5.
//  Copyright © 2018年 com.black. All rights reserved.
//

import Foundation

func PrintAttributes(attrs: [Attribute]) {
    for a in attrs {
        print("<position x:\(a.position.x) y:\(a.position.y) z:\(a.position.z), normal x:\(a.normal.x) y:\(a.normal.y) z:\(a.normal.z) >")
    }
}
