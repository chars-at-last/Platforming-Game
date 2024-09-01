shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

void fragment()
{
	vec4 raw_color = textureLod(screen_texture, SCREEN_UV, 0.f);
	ivec4 temp_color = ivec4(raw_color * 255.f);
	COLOR = vec4(float(temp_color.r >> 3) / 32.f, float(temp_color.g >> 2) / 64.f, float(temp_color.b >> 3) / 32.f, raw_color.a);
}