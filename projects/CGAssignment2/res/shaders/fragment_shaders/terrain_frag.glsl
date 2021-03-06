#version 440

#include "../fragments/fs_common_inputs.glsl"

layout(location = 5) in vec3 inTextureWeights;

// We output a single color to the color buffer
layout(location = 0) out vec4 frag_color;

////////////////////////////////////////////////////////////////
/////////////// Frame Level Uniforms ///////////////////////////
////////////////////////////////////////////////////////////////

#include "../fragments/frame_uniforms.glsl"

////////////////////////////////////////////////////////////////
/////////////// Instance Level Uniforms ////////////////////////
////////////////////////////////////////////////////////////////

// Represents a collection of attributes that would define a material
// For instance, you can think of this like material settings in 
// Unity
struct Material {
	sampler2D DiffuseSand;
	sampler2D DiffuseGrass;
	sampler2D DiffuseSnow;
	sampler2D DiffuseStone;
	float     Shininess;
};
// Create a uniform for the material
uniform Material u_Material;

////////////////////////////////////////////////////////////////
///////////// Application Level Uniforms ///////////////////////
////////////////////////////////////////////////////////////////

#include "../fragments/multiple_point_lights.glsl"

const float LOG_MAX = 2.40823996531;

// https://learnopengl.com/Advanced-Lighting/Advanced-Lighting
void main() {
	// Normalize our input normal
	vec3 normal = normalize(inNormal);

	// Will accumulate the contributions of all lights on this fragment
	// This is defined in the fragment file "multiple_point_lights.glsl"
	vec3 lightAccumulation = CalcAllLightContribution(inWorldPos, normal, u_CamPos.xyz, u_Material.Shininess);

	// By we can use this lil trick to divide our weight by the sum of all components
	// This will make all of our texture weights add up to one! 
	vec3 texWeight = inTextureWeights / dot(inTextureWeights, vec3(1,1,1));

	// Perform our texture mixing, we'll calculate our albedo as the sum of the texture and it's weight
	vec4 textureColor = 
		texture(u_Material.DiffuseSand, inUV) * texWeight.x + 
		texture(u_Material.DiffuseGrass, inUV) * texWeight.y +
		texture(u_Material.DiffuseStone, inUV) * texWeight.z;

	// combine for the final result
	vec3 result = lightAccumulation  * inColor * textureColor.rgb;

	frag_color = vec4(result, textureColor.a);
}