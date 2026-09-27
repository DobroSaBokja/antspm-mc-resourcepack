#version 330
#extension GL_ARB_separate_shader_objects : require

#include <minecraft:dynamictransforms.glsl>
#include <minecraft:projection.glsl>

layout(location = 0) in vec3 Position;
layout(location = 1) in vec4 Color;

layout(location = 0) out vec4 vertexColor;

void main() {
    //gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);



    #if defined(IS_GUI)
    gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);
#else
    // --- 2.5D NAMETAG BACKGROUND MODIFICATION ---
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
#endif

    vertexColor = Color;
}
