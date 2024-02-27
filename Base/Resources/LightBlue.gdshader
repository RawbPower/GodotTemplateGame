shader_type canvas_item;

uniform bool active = true;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec4 color = texture(TEXTURE, UV);
	if (active)
	{
		color = vec4(153.0/255.0, 201.0/255.0, 179.0/255.0, texture(TEXTURE, UV).a);
	}
	
	COLOR = color;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
