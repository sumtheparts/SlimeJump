shader_type canvas_item;

uniform vec4 tint : source_color = vec4(1.0);
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;

void fragment() {
	vec4 color = texture(SCREEN_TEXTURE,SCREEN_UV);
	color = mix(color,tint,0.3);
	color = mix(vec4(0.5),color,1.4);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
