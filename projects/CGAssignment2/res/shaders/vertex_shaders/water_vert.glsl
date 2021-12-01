#version 440

// Include our common vertex shader attributes and uniforms
#include "../fragments/vs_common.glsl"


uniform float delta;

void main() {
	vec3 vert = inPosition;

	//sin function for wave
	vert.z = 0.1 * ((sin(vert.x * 5.0 + (u_Time/2)) * 0.1) + (sin(vert.y * 5.0 + (u_Time/2)) * 0.1));

	gl_Position = u_ModelViewProjection * vec4(vert, 1.0);

	// Pass vertex pos in world space to frag shader
	outWorldPos = (u_Model * vec4(vert, 1.0)).xyz;
	// Normals
	outNormal = mat3(u_NormalMatrix) * inNormal;
	// Pass our UV coords to the fragment shader
	outUV = inUV;
	///////////
	outColor = inColor;
}

