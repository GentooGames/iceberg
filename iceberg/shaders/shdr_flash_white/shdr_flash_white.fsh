varying vec2 v_vTexcoord;

void main() {
	vec4 tex_color	 = texture2D(gm_BaseTexture, v_vTexcoord);
	vec4 white_color = vec4(255.0, 255.0, 255.0, tex_color.a);
    gl_FragColor	 =  white_color; 
}
