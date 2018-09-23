//
//  pbr.h
//  Black-Mac
//
//  Created by AngusLi on 2018/9/6.
//  Copyright © 2018年 com.black. All rights reserved.
//

#ifndef pbr_h
#define pbr_h

#include <simd/simd.h>
using namespace simd;

float3 cookTorranceBRDF(float3 color, float3 N, float3 V, float3 L, float metalness, float roughness);

#endif /* pbr_h */
