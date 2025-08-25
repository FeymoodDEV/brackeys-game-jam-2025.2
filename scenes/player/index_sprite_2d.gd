@tool
class_name IndexSprite2D
extends Sprite2D

var base_color_palette : ColorPalette
@export var replacement_color_palette : ColorPalette : 
	set(new_palette):
		replacement_color_palette = new_palette
		feed_shader()

func read_palette_from_texture(texture: Texture2D) -> ColorPalette:
	if texture == null:
		return null
	var img = texture.get_image()
	var palette = ColorPalette.new()
	for x in img.get_width():
		for y in img.get_height():
			var rgb = img.get_pixel(x, y)
			if rgb not in palette.colors:
				palette.colors.append(rgb)
	return palette

func convert_palette_to_img(palette: ColorPalette) -> Image :
	var palette_byte_array : PackedByteArray = palette.colors.to_byte_array()
	var palette_img : Image = Image.create_from_data(
		palette_byte_array.size(), 
		1, 
		false, 
		Image.FORMAT_RGBA8, 
		palette_byte_array
	)
	return palette_img

func feed_shader():
	base_color_palette = read_palette_from_texture(texture)
	if base_color_palette.colors.size() >= replacement_color_palette.colors.size():
		base_color_palette.colors.resize(replacement_color_palette.colors.size())
	else:
		replacement_color_palette.colors.resize(base_color_palette.colors.size())
	
	material.set_shader_parameter("base_colors", convert_palette_to_img(base_color_palette)) 
	material.set_shader_parameter(
		"replacement_colors", 
		convert_palette_to_img(replacement_color_palette) if replacement_color_palette != null else null
	) 

func _ready() -> void:
	texture_changed.connect(feed_shader)
	feed_shader()
