varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float u_alpha;
uniform float u_color[3];

void main() {
	
	vec4 tex_color		= texture2D(gm_BaseTexture, v_vTexcoord);	
	
	float red_blend		= mix((u_color[0] / 255.0), tex_color.r, u_alpha);
	float green_blend	= mix((u_color[1] / 255.0), tex_color.g, u_alpha);
	float blue_blend	= mix((u_color[2] / 255.0), tex_color.b, u_alpha);
	float alpha_blend	= tex_color.a;
	
	gl_FragColor		= vec4(red_blend, green_blend, blue_blend, alpha_blend);
}