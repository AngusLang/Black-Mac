import simd

struct Attribute {
    var position: vector_float3;
    var normal: vector_float3;
}

struct Uniform {
    var matrix: matrix_float4x4
}
