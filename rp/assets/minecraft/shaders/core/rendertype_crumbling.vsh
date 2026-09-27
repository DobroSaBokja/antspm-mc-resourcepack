#version 330
#extension GL_ARB_separate_shader_objects : require

#include <minecraft:fog.glsl>
#include <minecraft:dynamictransforms.glsl>
#include <minecraft:projection.glsl>

layout(location = 0) in vec3 Position;
layout(location = 1) in vec4 Color;
layout(location = 2) in vec2 UV0;
layout(location = 3) in ivec2 UV2;

layout(location = 0) out float sphericalVertexDistance;
layout(location = 1) out float cylindricalVertexDistance;
layout(location = 2) out vec4 vertexColor;
layout(location = 3) out vec2 texCoord0;

void main() {
    //gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);
// --- 2.5D ENTITY MATRIX MODIFICATION ---
    vec3 translation = ModelViewMat[3].xyz;

    mat4 lockedMat = mat4(
        1.0, 0.0, 0.0, 0.0, // Locked X axis
        0.0, 1.0, 0.0, 0.0, // Locked Y axis
        0.0, 0.0, 1.0, 0.0, // Locked Z axis
        translation.x, translation.y, translation.z, 1.0 // Keep original location
    );

    vec4 viewPos = lockedMat * vec4(Position, 1.0);
    viewPos.z -= 6.0; 
    
    gl_Position = ProjMat * viewPos;
    // ---------------------------------------
    sphericalVertexDistance = fog_spherical_distance(Position);
    cylindricalVertexDistance = fog_cylindrical_distance(Position);
    vertexColor = Color;
    texCoord0 = UV0;
}
