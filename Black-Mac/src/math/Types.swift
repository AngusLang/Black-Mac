import simd

struct Attribute {
    var position: vector_float3;
    var normal: vector_float3;
}

struct VertexUniform {
    var matrix: matrix_float4x4
}

struct FragmentUniform {
    var cameraPosition: vector_float3;
}
