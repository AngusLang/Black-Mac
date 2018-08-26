//
//  Matrix3.swift
//  Black
//
//  Created by AngusLi on 2018/8/25.
//  Copyright © 2018年 lang. All rights reserved.
//

import Foundation

public class Matrix3 {
    var elements: Array<Float>
    
    init() {
        elements = [ 1, 0, 0, 0, 1, 0, 0, 0, 1]
    }
    
    @discardableResult
    func identity() -> Matrix3 {
        elements = [1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1]
        return self
    }
    
    @discardableResult
    func setFromMatrix4(_ m: Matrix4) -> Matrix3 {
        let me = m.elements;
        elements[0] = me[0]; elements[1] = me[4]; elements[2] = me[8];
        elements[3] = me[1]; elements[4] = me[5]; elements[5] = me[9];
        elements[6] = me[2]; elements[7] = me[6]; elements[8] = me[10];
        return self
    }
    
    
    @discardableResult
    func getInverse(_ m: Matrix3 ) -> Matrix3 {
        let me = m.elements,
        
        n11 = me[ 0 ], n21 = me[ 1 ], n31 = me[ 2 ],
        n12 = me[ 3 ], n22 = me[ 4 ], n32 = me[ 5 ],
        n13 = me[ 6 ], n23 = me[ 7 ], n33 = me[ 8 ],
        
        t11 = n33 * n22 - n32 * n23,
        t12 = n32 * n13 - n33 * n12,
        t13 = n23 * n12 - n22 * n13,
        
        det = n11 * t11 + n21 * t12 + n31 * t13;
        
        if det == 0 {
            print("matrix is degenerate")
            return self.identity();
        }

        let detInv = 1 / det;
        
        elements[0] = t11 * detInv;
        elements[1] = ( n31 * n23 - n33 * n21 ) * detInv;
        elements[2] = ( n32 * n21 - n31 * n22 ) * detInv;
        
        elements[3] = t12 * detInv;
        elements[4] = ( n33 * n11 - n31 * n13 ) * detInv;
        elements[5] = ( n31 * n12 - n32 * n11 ) * detInv;
        
        elements[6] = t13 * detInv;
        elements[7] = ( n21 * n13 - n23 * n11 ) * detInv;
        elements[8] = ( n22 * n11 - n21 * n12 ) * detInv;
    
        return self
    }
    
    @discardableResult
    func transpose() -> Matrix3 {
        swap(&elements[1], &elements[3])
        swap(&elements[2], &elements[6])
        swap(&elements[5], &elements[7])
        return self
    }
    
    @discardableResult
    func getNormalMatrix(_ m: Matrix4) -> Matrix3 {
        return self.setFromMatrix4(m).getInverse(self).transpose()
    }
}
