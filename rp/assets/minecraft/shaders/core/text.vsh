#version 330
#extension GL_ARB_separate_shader_objects : require

#if !defined(IS_GUI) && !defined(IS_SEE_THROUGH)
#include <minecraft:fog.glsl>
#include <minecraft:sample_lightmap.glsl>
#endif

#include <minecraft:dynamictransforms.glsl>
#include <minecraft:projection.glsl>

layout(location = 0) in vec3 Position;
layout(location = 1) in vec4 Color;
layout(location = 2) in vec2 UV0;
#if !defined(IS_GUI) && !defined(IS_SEE_THROUGH)
layout(location = 3) in ivec2 UV2;
#endif

#if !defined(IS_GUI) && !defined(IS_SEE_THROUGH)
uniform sampler2D Sampler2;
layout(location = 0) out float sphericalVertexDistance;
layout(location = 1) out float cylindricalVertexDistance;
#endif

layout(location = 2) out vec4 vertexColor;
layout(location = 3) out vec2 texCoord0;

void main() {
#if defined(IS_GUI)
    gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);
#else
    // Hack: Check if the text is pure white (typical nametag)
    // We use a small threshold (0.99) to account for floating point inaccuracies
    if (Color.a < 0.99 || (Color.r == 1.0 && Color.g == 1.0 && Color.b == 1.0)) {
        
        // --- NAMETAG LOGIC (Locked Rotation) ---
        vec3 translation = ModelViewMat[3].xyz;
        mat4 lockedMat = mat4(
            1.0, 0.0, 0.0, 0.0, 
            0.0, 1.0, 0.0, 0.0, 
            0.0, 0.0, 1.0, 0.0, 
            translation.x, translation.y, translation.z, 1.0 
        );
        vec4 viewPos = lockedMat * vec4(Position, 1.0);
        viewPos.z -= 6.0; 
        gl_Position = ProjMat * viewPos;

    } else {

        // --- SIGN LOGIC (Vanilla Rotation) ---
        vec4 viewPos = ModelViewMat * vec4(Position, 1.0);
        //viewPos.z -= 6.0; 
        gl_Position = ProjMat * viewPos;

    }
#endif

#if !defined(IS_GUI) && !defined(IS_SEE_THROUGH)
    sphericalVertexDistance = fog_spherical_distance(Position);
    cylindricalVertexDistance = fog_cylindrical_distance(Position);
    vertexColor = Color * sample_lightmap(Sampler2, UV2);
#else
    vertexColor = Color;
#endif
    texCoord0 = UV0;
}