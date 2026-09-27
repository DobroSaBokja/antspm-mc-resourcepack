#version 330
#extension GL_ARB_separate_shader_objects : require

#include <minecraft:fog.glsl>
#include <minecraft:dynamictransforms.glsl>
#include <minecraft:projection.glsl>

layout(location = 0) in vec3 Position;

layout(location = 0) out float sphericalVertexDistance;
layout(location = 1) out float cylindricalVertexDistance;

void main() {
    //gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);
// --- 2.5D WORLD-SPACE MODIFICATION ---
    // Note: If the file uses a custom position variable (like 'pos' instead of 'Position'), 
    // change 'Position.x', 'Position.y', and 'Position.z' to match it.
    vec4 lockedViewPos = vec4(Position.x, Position.y, Position.z - 6.0, 1.0);
    gl_Position = ProjMat * lockedViewPos;
    // -------------------------------------


    sphericalVertexDistance = fog_spherical_distance(Position);
    cylindricalVertexDistance = fog_cylindrical_distance(Position);
}
