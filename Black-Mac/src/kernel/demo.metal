//
//  demo.metal
//  EGS-ios
//
//  Created by AngusLi on 2018/8/16.
//  Copyright © 2018年 qunhequnhe. All rights reserved.
//

#include <metal_stdlib>
#include <simd/simd.h>

using namespace metal;

struct Attribute
{
    float3 position     [[attribute(0)]];
    float3 normal       [[attribute(1)]];
};

struct Uniform {
    float4x4 matrix;
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
             constant Uniform &uniform [[buffer(1)]])
{
    Varying out;

    Attribute in = attribute[vid];
    
    out.v_position = uniform.matrix * float4(in.position * 0.5, 1.0);
    out.v_normal = in.normal;
    out.v_color = float4((in.position + 1.0) / 2.0, 1.0);

    return out;
}



fragment float4
fragmentShader(Varying in [[stage_in]])
{
    float3 light_direction = normalize(float3(-1.0));
    float3 ambient = float3(0.2);
    float radiance = saturate(dot(light_direction, in.v_normal));
    return float4(mix(ambient, float3(radiance), 0.2), 1.0);
}
