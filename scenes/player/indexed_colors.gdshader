shader_type canvas_item;

uniform sampler2D base_colors;
uniform sampler2D replacement_colors;

void fragment() {
	vec4 original_color = COLOR;
	// iterate through base palette to find this color
	bool color_found = false;
	int i = 0;
	while(i < textureSize(base_colors,0).x && !color_found) {
		vec4 palette_color = texelFetch(base_colors, ivec2(i, 0), 0);
		if (original_color == palette_color) {
			color_found = true;
			vec4 replacement_color = texelFetch(replacement_colors, ivec2(i,0), 0);
			COLOR = replacement_color;
		}
		i++;
	}
	if (!color_found) {
		COLOR = COLOR;
	}
}
