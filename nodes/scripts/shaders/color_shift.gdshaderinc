// Canvas Item shader for changing one color to another.

// Variable(s)
uniform vec4 base_color : source_color;
uniform vec4 change_color : source_color;
uniform float tolerance : hint_range(0.f, 1.f, .01f) = .01;

uniform bool do_change = true;


vec4 shift(vec4 color) {
	// Called for every pixel the material is visible on.
	if(do_change)
		if(distance(color, base_color) / 2.f < tolerance)
			color = change_color;

	return color;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
