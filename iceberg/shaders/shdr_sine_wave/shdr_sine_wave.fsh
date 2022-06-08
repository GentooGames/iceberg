varying vec2  v_vTexcoord;
varying vec4  v_vColour;

uniform float u_time;
uniform vec2  u_texel;
uniform vec3  u_x_props;	// [u_x_speed, u_x_freq, u_x_size]
uniform vec3  u_y_props;	// [u_y_speed, u_y_freq, u_y_size]

void main() {	
	float x_wave = sin(u_time * u_x_props.x + v_vTexcoord.x * u_x_props.y) * (u_x_props.z * u_texel.y);
	float y_wave = sin(u_time * u_y_props.x + v_vTexcoord.y * u_y_props.y) * (u_y_props.z * u_texel.x);
    gl_FragColor = v_vColour * texture2D(gm_BaseTexture, v_vTexcoord + vec2(x_wave, y_wave));
}
