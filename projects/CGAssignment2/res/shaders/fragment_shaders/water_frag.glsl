#version 410
layout(location=1) in vec4 color;
layout(location=2) in vec2 texUV;

out vec4 frag_color;

uniform sampler2D myTextureSampler;

void main() { 
	
	frag_color = texture(myTextureSampler, texUV);// * vec4(color, 1.0);
}