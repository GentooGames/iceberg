varying vec2  v_vTexcoord;
uniform float u_time;
uniform float u_alpha;
uniform vec2  u_uvs1;
uniform vec2  u_uvs2;
uniform float u_rand;

float rand(vec2 n) {
	return fract(cos(dot(n, vec2(12.9898, 4.1414))) * u_rand);	
}

float noise(vec2 n) {
	vec2 dd = vec2(0.0, 1.0);
	vec2 bb = floor(n);
	vec2 ff = smoothstep(vec2(0.0), vec2(1.0), fract(n));
	return mix(mix(rand(bb), rand(bb + dd.yx), ff.x), mix(rand(bb + dd.xy), rand(bb + dd.yy), ff.x), ff.y);
}

float fbm(vec2 n) {
	return noise(n) * 0.5 + noise(n * 2.0) * 0.25 + noise(n * 4.0) * 0.124 + noise(n * 8.0) * 0.065;
}

void main() {
	float dist = distance(vec2(u_uvs1.x, u_uvs1.y), vec2(u_uvs2.x, u_uvs2.y));
	vec2 uv = vec2(v_vTexcoord.x / dist, v_vTexcoord.y / dist);
	vec2 pp = vec2(uv.x * 5.0, -uv.y * 10.0);
	float rr = fbm(pp + vec2(fbm(pp) + u_time * 0.1, 0.0));
    gl_FragColor = vec4(rr, rr, rr, smoothstep(0.1, 1.0, rr) * u_alpha);
}
