//
//  demo.metal
//  EGS-ios
//
//  Created by AngusLi on 2018/8/16.
//  Copyright © 2018年 qunhequnhe. All rights reserved.
//

#include <metal_stdlib>
#include <simd/simd.h>
#include "./lib/pbr.h"

using namespace metal;

struct Attribute
{
    float3 position     [[attribute(0)]];
    float3 normal       [[attribute(1)]];
};

struct VertexUniform {
    float4x4 matrix;
};

struct FragmentUniform {
    float3 camera_position;
};

struct Varying
{
    float4 v_position [[position]];
    float3 v_normal;
    float4 v_color;
};

vertex Varying
vertexShader(uint vid [[vertex_id]],
             device Attribute * attribute [[buffer(0)]],
             constant VertexUniform &uniform [[buffer(1)]])
{
    Varying out;

    Attribute in = attribute[vid];
    
    out.v_position = uniform.matrix * float4(in.position * 0.5, 1.0);
    out.v_normal = in.normal;
    out.v_color = float4((in.position + 1.0) / 2.0, 1.0);

    return out;
}

fragment float4
fragmentShader(Varying in [[stage_in]],
               constant FragmentUniform &uniform [[buffer(0)]])
{
    float3 L = normalize(float3(1.0));
    float3 N = in.v_normal;
    float3 V = normalize(uniform.camera_position - in.v_position.xyz);
    float3 color = float3(0.2, 0.3, 0.7);
    float3 irradience = cookTorranceBRDF(color, N, V, L, 0.25, 0.01);
    return float4(irradience, 1.0);
}
