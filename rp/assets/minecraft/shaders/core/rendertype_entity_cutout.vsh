#version 330

#include <minecraft:fog.glsl>

layout(location = 0) in vec3 Position;
layout(location = 1) in vec4 Color;
layout(location = 2) in vec2 UV0;
layout(location = 3) in ivec2 UV1;
layout(location = 4) in ivec2 UV2;
layout(location = 5) in vec3 Normal;

uniform sampler2D Sampler2;
uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform int FogShape;

layout(location = 0) out float vertexDistance;
layout(location = 1) out vec4 vertexColor;
layout(location = 2) out vec2 texCoord0;

void main() {
    // 1. Transform the entity's local position into camera-relative space
    vec4 viewPos = ModelViewMat * vec4(Position, 1.0);
    
    // --- ANIMAL CROSSING CURVE MATH ---
    // Calculate the distance squared using the X and Z axes
    float distSq = (viewPos.x * viewPos.x) + (viewPos.z * viewPos.z);
    
    // Apply the curvature to the Y axis (use the exact same number as your terrain!)
    viewPos.y -= distSq * 0.005;
    // ----------------------------------

    // 2. Project the curved view position onto the 2D screen
    gl_Position = ProjMat * viewPos;

    vertexDistance = fog_distance(viewPos.xyz, FogShape);
    vertexColor = Color * texture(Sampler2, UV2 / 256.0);
    texCoord0 = UV0;
}