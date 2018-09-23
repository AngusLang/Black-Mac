import simd

struct Attribute {
    var position: float3;
    var normal: float3;
}

struct Matrix4Uniform {
    var matrix: matrix_float4x4
}

struct Matrix3Uniform {
    var matrix: matrix_float3x3
}

struct VertexUniform {
    var matrix: matrix_float4x4
}

struct GlobalFragmentUniform {
    var cameraPosition: float3;
}

struct LocalFragmentUniform {
    var color: float3;
}
