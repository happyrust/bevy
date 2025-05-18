struct VertexOutput {
    @builtin(position) clip_position: vec4<f32>,
};

@vertex
fn vs_main(@builtin(vertex_index) in_vertex_index: u32) -> VertexOutput {
    var out: VertexOutput;
    
    // 画一个简单的三角形
    let x = f32(i32(in_vertex_index & 1u));
    let y = f32(i32(in_vertex_index >> 1u));
    
    out.clip_position = vec4<f32>(x * 2.0 - 1.0, y * 2.0 - 1.0, 0.0, 1.0);
    return out;
}

@fragment
fn fs_main() -> @location(0) vec4<f32> {
    return vec4(1.0, 0.0, 0.0, 1.0); // 纯红色
} 