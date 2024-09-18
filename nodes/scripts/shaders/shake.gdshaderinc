// Shake shader

#include "random.gdshaderinc"

// Variable(s)
uniform float shake_amount = 1;


vec2 shake(vec2 position) {
	if(!bool(shake_amount))
		return position;
	else
	{
		float shake_offset = shake_amount / 2.f;
		return position + (shake_amount - shake_offset) * vec2(random(vec2(TIME, 0.f)), random(vec2(0.f, TIME)));
	}
}


//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
