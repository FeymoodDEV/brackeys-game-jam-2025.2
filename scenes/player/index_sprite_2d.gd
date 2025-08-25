@tool
class_name IndexSprite2D
extends Sprite2D

var base_color_palette : ColorPalette
@export var replacement_color_palette : ColorPalette : 
	set(new_palette):
		replacement_color_palette = new_palette
		feed_shader()

## Pixels with alpha below this value will be ignored when the base palette is created.
@export_range(0.0, 1.0, 0.01) var BASE_PALETTE_TRANSPARENCY_THRESHOLD : float = 0.01

## From `texture`, create a ColorPalette resource featuring every non transparent color
## in the texture.
func read_palette_from_texture(texture: Texture2D) -> ColorPalette:
	if texture == null:
		return null
	var img = texture.get_image()
	
	var colors : PackedColorArray = []
	
	for x in img.get_width():
		for y in img.get_height():
			var rgba = img.get_pixel(x, y)
			if rgba not in colors and rgba.a >= BASE_PALETTE_TRANSPARENCY_THRESHOLD:
				colors.append(rgba)
	
	var palette = ColorPalette.new()
	palette.colors = colors
	return palette

## Convert a ColorPalette to an Image object. Colors translate to pixels in a single row.
func convert_palette_to_img(palette: ColorPalette) -> Image:
	var colors := palette.colors
	var size := colors.size()
	var palette_img := Image.create_empty(size, 1, false, Image.FORMAT_RGBA8)
	for i in size:
		var x := i
		var y := 0
		palette_img.set_pixel(x, y, colors[i])
	return palette_img

## Provides the palettes to the shader.
func feed_shader():
	# get the base palette from current sprite
	base_color_palette = read_palette_from_texture(texture)
	
	# truncate the larger palette to the size of the smaller one
	if base_color_palette.colors.size() >= replacement_color_palette.colors.size():
		var truncated_palette = base_color_palette.colors
		truncated_palette.resize(replacement_color_palette.colors.size())
		base_color_palette.colors = truncated_palette
	else:
		var truncated_palette = replacement_color_palette.colors
		truncated_palette.resize(base_color_palette.colors.size())
		replacement_color_palette.colors = truncated_palette
	
	# Debug: save images to look at em
	#convert_palette_to_img(base_color_palette).save_png("base.png")
	#convert_palette_to_img(replacement_color_palette).save_png("repl.png")
	
	
	# convert palettes to images and give them to the shader
	material.set_shader_parameter(
		"base_colors", 
		ImageTexture.create_from_image(convert_palette_to_img(base_color_palette))
	) 
	# if no replacement palette is set, just use the base one
	# i know this sucks bum
	material.set_shader_parameter(
		"replacement_colors", 
		ImageTexture.create_from_image(
			convert_palette_to_img(replacement_color_palette) 
			if replacement_color_palette != null 
			else null
		)
	) 

func _ready() -> void:
	texture_changed.connect(feed_shader)
	feed_shader()
