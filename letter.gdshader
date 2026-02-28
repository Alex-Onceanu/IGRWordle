shader_type canvas_item;
uniform vec3 clr;

void fragment() {
	COLOR = vec4(clr, texture(TEXTURE, UV).a);
}
