extends Node2D

@export var map_width: int = 40
@export var map_height: int = 30
@export var block_scenes: Array[PackedScene]
@export var border_scene: PackedScene
@export var cell_size: int = 64

@export var cluster_chance: float = 0.01
@export var cluster_size: int = 4

func _ready():
	generate_level()

func generate_level():
	for y in range(map_height):
		for x in range(map_width):
			var is_border = (x == 0 or x == map_width-1 or y == 0 or y == map_height-1)

			if is_border:
				spawn_block(border_scene, x, y)
			else:
				# Random chance to start a cluster
				if randf() < cluster_chance:
					spawn_cluster(x, y)


func spawn_cluster(start_x: int, start_y: int):
	# Place a block at the center
	spawn_block(block_scenes[randi() % block_scenes.size()], start_x, start_y)

	for i in range(cluster_size):
		var offset_x = randi_range(-1, 1)
		var offset_y = randi_range(-1, 1)

		var nx = clamp(start_x + offset_x, 1, map_width - 2)
		var ny = clamp(start_y + offset_y, 1, map_height - 2)

		spawn_block(block_scenes[randi() % block_scenes.size()], nx, ny)


func spawn_block(scene: PackedScene, x: int, y: int):
	var block = scene.instantiate()
	block.position = Vector2(x * cell_size, y * cell_size)
	add_child(block)
