varying vec2  v_vTexcoord;
varying vec4  v_vColour;

uniform float u_time;
uniform vec2  u_texel;

const float x_speed	= 0.005;
const float x_freq	= 20.0;
const float x_size	= 0.2;
const float y_speed	= 0.005;
const float y_freq	= 20.0;
const float y_size	= 0.2;

void main() {	
	float x_wave = sin(u_time * x_speed + v_vTexcoord.x * x_freq) * (x_size * u_texel.y);
	float y_wave = sin(u_time * y_speed + v_vTexcoord.y * y_freq) * (y_size * u_texel.x);
    gl_FragColor = v_vColour * texture2D(gm_BaseTexture, v_vTexcoord + vec2(x_wave, y_wave));
}
