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
#include "./lib/common.h"

using namespace metal;

struct Attribute
{
    float3 position     [[attribute(0)]];
    float3 normal       [[attribute(1)]];
};

struct Matrix4Uniform {
    float4x4 matrix;
};

struct Matrix3Uniform {
    float3x3 matrix;
};

struct GlobalFragmentUniform {
    float3 camera_position;
};

struct LocalFragmentUniform {
    float3 color;
};

struct Varying
{
    float4 v_position [[position]];
    float3 v_normal;
    float3 v_eye;
};

vertex Varying
vertexShader(uint vid [[vertex_id]],
             device Attribute * attribute [[buffer(0)]],
             constant Matrix4Uniform &projectionMatrixUniform [[buffer(1)]],
             constant Matrix4Uniform &viewModelMatrixUniform [[buffer(2)]],
             constant Matrix4Uniform &normalMatrixUniform [[buffer(3)]])
{
    Varying out;

    Attribute in = attribute[vid];
    
    out.v_position = projectionMatrixUniform.matrix * viewModelMatrixUniform.matrix * float4(in.position, 1.0);
    out.v_normal = (normalMatrixUniform.matrix * float4(in.normal, 0.0)).xyz;

    return out;
}

fragment float4
fragmentShader(Varying in [[stage_in]],
               constant GlobalFragmentUniform &g_uniform [[buffer(0)]],
               constant LocalFragmentUniform &l_uniform [[buffer(1)]],
               texture2d<float> envmap [[texture(0)]],
               sampler defaultSampler [[sampler(0)]])
{
    float3 N = in.v_normal;
    float3 R = normalize(N);

    float m = sqrt(pow(R.x, 2.) + pow(R.y, 2.) + pow(R.z + 1., 2.));
    float2 uv = R.xy / m * .55 + .5;
    float3 color = envmap.sample(defaultSampler, 1.0 - uv).zyx + l_uniform.color;
    return float4(color, 1.);
}
