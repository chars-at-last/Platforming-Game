// Gun Shader

shader_type canvas_item;

#include "shake.gdshaderinc"
#include "color_shift.gdshaderinc"


void vertex()
{
	VERTEX = shake(VERTEX);
}

void fragment() {
	COLOR = shift(COLOR);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
