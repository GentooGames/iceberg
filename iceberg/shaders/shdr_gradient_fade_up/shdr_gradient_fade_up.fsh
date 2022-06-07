varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec4 u_uvs;
uniform float u_alpha_target;
uniform float u_alpha_scale;

void main() {
	vec4 col = v_vColour * texture2D(gm_BaseTexture, v_vTexcoord);
	vec2 uv1 = vec2(u_uvs.x, u_uvs.y);
	vec2 uv2 = vec2(u_uvs.z, u_uvs.w);
	float dist = distance(vec2(uv1.x, uv1.y), vec2(uv2.x, uv2.y));
	vec2 uv = vec2(v_vTexcoord.x / dist, v_vTexcoord.y / dist);
	
	float fade = (uv1.y - v_vTexcoord.y) / (uv1.y - uv2.y);
	col.a = mix(1.0, fade, (1.0 - u_alpha_target)) * u_alpha_scale;
    gl_FragColor = col;
}
