//! 这个着色器用于渲染对象的picking ID
//! 每个对象将使用唯一的颜色渲染，可用于物体选择

// 从bevy_pbr导入必要的功能
#import bevy_pbr::{
    mesh_functions,
    view_transformations::position_world_to_clip
}

struct Vertex {
    // 实例索引，用于批处理和GPU预处理
    @builtin(instance_index) instance_index: u32,
    // 位置属性在位置0
    @location(0) position: vec3<f32>,
    // 可选：如果需要纹理坐标
    // @location(1) uv: vec2<f32>,
};

// 顶点着色器输出，同时作为片段着色器的输入
struct VertexOutput {
    @builtin(position) clip_position: vec4<f32>,
    @location(0) world_position: vec4<f32>,
    // 我们通过实例ID传递唯一ID
    @location(1) instance_id: u32,
};

// 顶点着色器
@vertex
fn vertex(vertex: Vertex) -> VertexOutput {
    var out: VertexOutput;
    
    // 获取世界变换矩阵
    var world_from_local = mesh_functions::get_world_from_local(vertex.instance_index);
    
    // 转换位置到世界空间
    out.world_position = mesh_functions::mesh_position_local_to_world(
        world_from_local, 
        vec4<f32>(vertex.position, 1.0)
    );
    
    // 转换到裁剪空间
    out.clip_position = position_world_to_clip(out.world_position.xyz);
    
    // 传递实例ID作为唯一标识符
    out.instance_id = vertex.instance_index;
    
    return out;
}

// 片段着色器
@fragment
fn fragment(in: VertexOutput) -> @location(0) vec4<f32> {
    // 从实例ID生成唯一颜色
    // 使用简单哈希将ID映射到RGB值
    let id = in.instance_id;
    let r = f32((id & 0xFFu)) / 255.0;
    let g = f32(((id >> 8u) & 0xFFu)) / 255.0;
    let b = f32(((id >> 16u) & 0xFFu)) / 255.0;
    
    return vec4<f32>(r, g, b, 1.0);
} 