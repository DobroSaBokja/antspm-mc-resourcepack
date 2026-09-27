#version 330
#extension GL_ARB_separate_shader_objects : require

#include <minecraft:dynamictransforms.glsl>
#include <minecraft:projection.glsl>

layout(location = 0) in vec3 Position;
layout(location = 1) in vec2 UV0;

layout(location = 0) out vec2 texCoord0;

void main() {
    vec3 pos = Position + ModelOffset;
    // --- 2.5D WORLD-SPACE MODIFICATION ---
    // Note: If the file uses a custom position variable (like 'pos' instead of 'Position'), 
    // change 'Position.x', 'Position.y', and 'Position.z' to match it.
    vec4 lockedViewPos = vec4(pos.x, pos.y, pos.z - 6.0, 1.0);
    gl_Position = ProjMat * lockedViewPos;
    // -------------------------------------

    texCoord0 = (TextureMat * vec4(UV0, 0.0, 1.0)).xy;
}
