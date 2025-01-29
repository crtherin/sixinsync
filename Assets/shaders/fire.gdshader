shader_type canvas_item;

uniform sampler2D noise_tex : hint_default_white;
uniform vec4 bottom_color : source_color = vec4(0.0, 0.7, 1.0, 1.0);
uniform vec4 middle_color : source_color = vec4(0.61, 0.69, 0.61, 1.0);
uniform vec4 top_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform float fire_alpha : hint_range(0.0, 1.0) = 0.249;
uniform vec2 fire_speed = vec2(-0.015, 0.015);
uniform float fire_aperture : hint_range(0.0, 3.0) = 0.326;

vec4 _mix_colors(vec4 color_1, vec4 color_2, vec4 color_3, float position) {
    position = clamp(position, 0.0, 1.0);

    if (position < 0.5) {
        return mix(color_1, color_2, position * 2.0);
    } else {
        return mix(color_1, color_3, (position - 0.5) * 2.0);
    }
}

void fragment() {
	vec2 base_uv = UV * 1.0;
	vec2 shifted_uv1 = base_uv + TIME * fire_speed;
	vec2 shifted_uv2 = base_uv + TIME * fire_speed * 1.5;

	float fire_noise1 = texture(noise_tex, fract(shifted_uv1)).r;
	float fire_noise2 = texture(noise_tex, fract(shifted_uv2)).r;
	float combined_noise = (fire_noise1 + fire_noise2) * 0.5;
	float noise = UV.y * (((UV.y + fire_aperture) * combined_noise - fire_aperture) * 75.0);

	noise += sin(UV.y * 10.0 + TIME * 2.0) * 0.1;

	float gradient_pos = clamp(noise * 0.08, 0.3, 2.0);
	vec4 fire_color = _mix_colors(bottom_color, middle_color, top_color, gradient_pos);

	COLOR = fire_color;
	COLOR.a = clamp(noise, 0.0, 1.0) * fire_alpha;
}
