//
//  pbr.metal
//  Black
//
//  Created by AngusLi on 2018/8/25.
//  Copyright © 2018年 lang. All rights reserved.
//

#include <metal_stdlib>
#include "./common.h"
using namespace metal;

float D_Func(float NdotH, float roughness) {
    float a = roughness * roughness;
    float NdotH_Sq = NdotH * NdotH;
    
    float nom = a;
    float denom = (NdotH_Sq * (a - 1.0) + 1.0);
    denom = PI * denom * denom;
    return nom / denom;
}

float GeometrySchlickGGX(float NdotV, float k) {
    float nom = NdotV;
    float denom = NdotV * (1.0 - k) + k;
    return nom / denom;
}

float G_Func(float NdotL, float NdotV, float roughness) {
    float k = roughness * roughness * .5;
    float g1 = GeometrySchlickGGX(NdotL, k);
    float g2 = GeometrySchlickGGX(NdotV, k);
    return g1 * g2;
}

float3 F_Func(float HdotV, float3 F0) {
    return F0 + (1.0 - F0) * pow(1.0 - HdotV, 5.0);
}

float3 cookTorranceBRDF(float3 color, float3 N, float3 V, float3 L, float metalness, float roughness) {
    float NdotV = saturate(dot(N, V));
    float NdotL = saturate(dot(N, L));
    float3 H = normalize(V + L);
    float NdotH = saturate(dot(N, H));
    float HdotV = saturate(dot(H, V));
    
    float D = D_Func(NdotH, roughness);
    float G = G_Func(NdotV, NdotL, roughness);
    
    float3 F0 = float3(0.04);
    F0 = mix(F0, color, metalness);
    float3 F = F_Func(HdotV, F0);

    return saturate(float3(D * G) * F / (NdotL * NdotV) * .25);
}
