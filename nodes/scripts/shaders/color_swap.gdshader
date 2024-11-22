shader_type canvas_item;

uniform vec4 from : source_color;
uniform vec4 to : source_color;
uniform float threshold : hint_range(0, 1, .1) = .1;
uniform float alpha_threshold : hint_range(0, 1, .1) = .5;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	if(length(COLOR.rgb - from.rgb) <= threshold && COLOR.a >= alpha_threshold)
		COLOR = to;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
