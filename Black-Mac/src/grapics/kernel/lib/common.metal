//
//  common.metal
//  Black-Mac
//
//  Created by AngusLi on 2018/9/6.
//  Copyright © 2018年 com.black. All rights reserved.
//

#include <metal_stdlib>
#include "./common.h"

using namespace metal;

float3 gamma(float3 i) {
    return pow(i, 2.2);
}


