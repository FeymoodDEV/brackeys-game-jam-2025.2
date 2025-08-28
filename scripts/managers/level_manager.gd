extends Node2D
class_name LevelManager

var player: PlayerController

## map width and height references cell count
@export var map_width: int = 40
@export var map_height: int = 30

@export var cell_size: int = 64 #px

## so blocks are being placed in clusters rather scattered around
@export var cluster_chance: float = 0.01
@export var cluster_size: int = 4

@export var player_scene: PackedScene
@export var border_scene: PackedScene

@export var block_scenes: Array[PackedScene]
@export var enemy_scenes: Array[PackedScene]
@export var background_tiles: Array[Texture]

var grid: Array = []
var rng: RandomNumberGenerator = RandomNumberGenerator.new()

func _ready():
	EventManager.player_spawned.connect(_level_ready);

func _level_ready(player_path: NodePath) -> void:
	player = get_node(player_path)
	$BG.texture = background_tiles[randi() % background_tiles.size()]
	
	# Initialize grid with false in order to track empty cells
	grid.resize(map_height)
	for y: int in range(grid.size()):
		grid[y] = []
		grid[y].resize(map_width)
		for x: int in range(map_width):
			grid[y][x] = false
			
	generate_level()
	#spawn_enemies()
	spawn_player()
	assign_target_for_bullet_patterns()

func generate_level() -> void:
	for y: int in range(map_height):
		for x: int in range(map_width):
			var is_border: bool = (x == 0 or x == map_width-1 or y == 0 or y == map_height-1)

			if is_border:
				spawn_block(border_scene, x, y)
			else:
				if randf() < cluster_chance and not grid[y][x]:
					spawn_cluster(x, y)

func spawn_cluster(start_x: int, start_y: int) -> void:
	# Place a block at the center
	spawn_block(block_scenes[randi() % block_scenes.size()], start_x, start_y)

	for i: int in range(cluster_size):
		var offset_x: int = randi_range(-1, 1)
		var offset_y: int = randi_range(-1, 1)

		var nx: Variant = clamp(start_x + offset_x, 1, map_width - 2)
		var ny: Variant = clamp(start_y + offset_y, 1, map_height - 2)

		spawn_block(block_scenes[randi() % block_scenes.size()], nx, ny)

func spawn_block(scene: PackedScene, x: int, y: int) -> void:
	if grid[y][x]:  # already occupied
		return

	var block: Block = scene.instantiate()
	block.position = Vector2(x * cell_size, y * cell_size)
	get_parent().add_child.call_deferred(block)

	grid[y][x] = true  # mark as occupied

## UNFINISHED AND UNSURE ON HOW I WANT TO SPAWN ENEMIES
func spawn_enemies() -> void:
	for y: int in range(map_height):
		for x: int in range(map_width):
			if grid[y][x] == false:
				if rng.randi_range(1, 10) != 1: continue
				grid[y][x] = true
				var enemy: EnemyController = enemy_scenes[randi() % enemy_scenes.size()].instantiate()
				enemy.position = Vector2(x * cell_size, y * cell_size)
				get_parent().add_child.call_deferred(enemy)

## finds one open cell where to place enemy
func spawn_player() -> void:
	var mid_x: int = int(map_width / 2)
	var mid_y: int = int(map_height / 2)

	var candidates: Array = []

	# Check a "middle box" (about 1/3 of the map size in the center)
	var range_x: int = int(map_width / 3)
	var range_y: int = int(map_height / 3)

	for y: int in range(mid_y - range_y, mid_y + range_y):
		for x: int in range(mid_x - range_x, mid_x + range_x):
			if x > 0 and x < map_width-1 and y > 0 and y < map_height-1:
				if not grid[y][x]:
					candidates.append(Vector2i(x, y))

	if candidates.size() == 0:
		print("⚠ No free middle cell found for player!")
		return

	var chosen: Vector2i = candidates[randi() % candidates.size()]

	player.global_position = Vector2(chosen.x * cell_size, chosen.y * cell_size)
	grid[chosen.y][chosen.x] = true

## We need to do this otherwise the patterns won't rotate correctly
func assign_target_for_bullet_patterns() -> void:
	pass
