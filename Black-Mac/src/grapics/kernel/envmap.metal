//
//  envmap.metal
//  Black-Mac
//
//  Created by AngusLi on 2018/9/6.
//  Copyright © 2018年 com.black. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

struct Attribute {
    float2 position [[attribute(0)]];
    float2 uv       [[attribute(1)]];
};

struct Varying {
    float4 v_position [[position]];
    float2 v_uv;
};

vertex Varying
envmapVertexShader(uint vid [[vertex_id]],
                   device Attribute * attribute [[buffer(0)]])
{
    Varying out;
    Attribute in = attribute[vid];
    
    out.v_position = float4(in.position, 0.0, 1.0);
    out.v_uv = in.uv;
    return out;
}

fragment float4
envmapFragmentShader(Varying in [[stage_in]],
                    texture2d<float> envmap [[texture(0)]])
{
    float2 uv = in.v_uv;
    constexpr sampler linearSampler (filter::linear, coord::normalized);
    float4 color = envmap.sample(linearSampler, uv);
    return float4(color);
}
