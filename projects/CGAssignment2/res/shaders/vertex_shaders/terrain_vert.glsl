#version 440

// Include our common vertex shader attributes and uniforms
#include "../fragments/vs_common.glsl"

#include "../fragments/math_constants.glsl"

layout(location = 5) out vec3 outTexWeights;

uniform float u_Scale;
uniform sampler2D u_heightMapSampler;

void main() {
	
	vec3 vert = inPosition;
	vert.z = texture(u_heightMapSampler, inUV).r;

	gl_Position = u_ModelViewProjection * vec4(vert, 1.0);

	// Pass vertex pos in world space to frag shader
	outWorldPos = (u_Model * vec4(vert, 1.0)).xyz;
	// Normals
	outNormal = mat3(u_NormalMatrix) * inNormal;
	// Pass our UV coords to the fragment shader
	outUV = inUV;
	///////////
	outColor = inColor;

	// We have some calculation to determine the texture weights
	// In this case, we are going to use cos and sin to generate texture
	// weights based on the z coord of the model in world coords
	outTexWeights = vec3( //The more the weight the 
		0.5*cos((u_Scale * outWorldPos.z) / 5) + 0.5, //Sand
		sin((u_Scale * outWorldPos.z + (1.5 * M_PI))/5) + 1, //Grass
		sqrt(abs(outWorldPos.z))/7 //Stone
	);
}

