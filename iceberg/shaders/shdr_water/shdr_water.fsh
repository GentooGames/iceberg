varying vec2  v_vTexcoord;

uniform float u_contrast;
uniform float u_cutoff;
uniform vec3  u_color;

void main() {
	vec4 base_color = texture2D(gm_BaseTexture, v_vTexcoord);
	
	// Grayscale
	float avg		= (base_color.r + base_color.g + base_color.b) / 3.0;
	base_color.rgb  = vec3(avg);
	
	// Contrast - Gamma
	base_color.rgb	= pow(base_color.rgb, vec3(1.0 / u_contrast)); 
	
	// Color Swap
	base_color.r	= mix((u_color.r / 255.0), base_color.r, 0.1);
	base_color.g	= mix((u_color.g / 255.0), base_color.g, 0.1);
	base_color.b	= mix((u_color.b / 255.0), base_color.b, 0.1);
	
	// Adjust Color
	if (base_color.g > u_cutoff) {
		//base_color.a = 0.0;
		
		base_color.r += 0.2;
		base_color.g += 0.2;
		base_color.b += 0.2;
	}
		
	// Fade Out
	base_color.a    = base_color.b * 0.2;
	gl_FragColor	= base_color;
}
