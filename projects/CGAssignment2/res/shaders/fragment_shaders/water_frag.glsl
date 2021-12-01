#version 440

layout(location = 0) in vec3 inWorldPos;
layout(location = 1) in vec4 inColor;
layout(location = 2) in vec3 inNormal;
layout(location = 3) in vec2 inUV;


uniform sampler2D u_WaterDiffuse;

uniform float alpha = 1.0f;

// We output a single color to the color buffer
layout(location = 0) out vec4 frag_color;

void main() { 
	
	vec4 tex = texture(u_WaterDiffuse, inUV);

	frag_color = tex;// * vec4(color, 1.0);
}