extends Node2D
class_name LevelManager

var player: PlayerController
var chosen: Vector2i

## map width and height references cell count
@export var map_width: int = 40
@export var map_height: int = 30

@export var cell_size: int = 64 #px

## so blocks are being placed in clusters rather scattered around
@export var cluster_chance: float = 0.01
@export var cluster_size: int = 4

@export var border_scene: PackedScene

@export var block_scenes: Array[PackedScene]
@export var enemy_scene: PackedScene = preload("res://prefabs/enemies/basic_enemy.tscn")
@export var enemy_datas: Array[EnemyData]
@export var background_tiles: Array[Texture]

@export var boss_scene: PackedScene
@export var next_level: PackedScene

var grid: Array = []
var rng: RandomNumberGenerator = RandomNumberGenerator.new()

func _enter_tree():
	EventManager.player_spawned.connect(_level_ready);
	EventManager.spawn_boss.connect(_on_boss_spawn)
	EventManager.boss_killed.connect(_on_boss_killed)

func _level_ready(player_path: NodePath) -> void:
	player = get_node(player_path)
	$BG.texture = background_tiles[randi() % background_tiles.size()]
	
	create_empty_grid()
	generate_level()
	spawn_enemies()
	place_player()

## Initialize grid with false in order to track empty cells
func create_empty_grid() -> void:
	grid.resize(map_height)
	for y: int in range(grid.size()):
		grid[y] = []
		grid[y].resize(map_width)
		for x: int in range(map_width):
			grid[y][x] = null

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

	grid[y][x] = block  # mark as occupied

## UNFINISHED AND UNSURE ON HOW I WANT TO SPAWN ENEMIES
func spawn_enemies() -> void:
	for y: int in range(map_height):
		for x: int in range(map_width):
			if grid[y][x] == null:
				if rng.randi_range(1, 15) != 1: continue
				var enemy: EnemyController = enemy_scene.instantiate()
				
				enemy.position = Vector2(x * cell_size, y * cell_size);
				enemy.enemy_data = enemy_datas[randi() % enemy_datas.size()]
				enemy.player = player;
				get_parent().add_child.call_deferred(enemy)
				
				grid[y][x] = enemy

## finds one open cell where to place player
func place_player() -> void:
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

	chosen = candidates[randi() % candidates.size()]

	player.global_position = Vector2(chosen.x * cell_size, chosen.y * cell_size)
	grid[chosen.y][chosen.x] = true

func _on_boss_spawn() -> void:
	assert(boss_scene, "setup Boss scene");
	
	var boss_instance: BossControler = boss_scene.instantiate()
	boss_instance.global_position = Vector2(chosen.x * cell_size, chosen.y * cell_size)
	get_parent().add_child(boss_instance)
	
	Spawning.clear_all_bullets()
	
	for enemy: EnemyController in get_tree().get_nodes_in_group("enemy"):
		enemy.die()
	for block: Block in get_tree().get_nodes_in_group("block"):
		block.die()

func _on_boss_killed() -> void:
	assert(next_level, "setup next level scene");
	# Start the slowdown effect
	await slow_motion(0.2, 1.0, 0.5)  # target_scale, duration, hold_time
	Spawning.clear_all_bullets()
	get_tree().change_scene_to_file(next_level.resource_path)

# Coroutine function for slow motion
func slow_motion(target_scale: float, duration: float, hold_time: float) -> void:
	var start_scale = Engine.time_scale
	var time_passed := 0.0

	# Smoothly lerp from current scale to target
	while time_passed < duration:
		time_passed += get_process_delta_time()
		var t = time_passed / duration
		Engine.time_scale = lerp(start_scale, target_scale, t)
		await get_tree().process_frame  # Wait a frame
	Engine.time_scale = target_scale

	# Hold slow motion for a few seconds
	await get_tree().create_timer(hold_time).timeout

	# Restore to normal speed with another lerp
	time_passed = 0.0
	while time_passed < duration:
		time_passed += get_process_delta_time()
		var t = time_passed / duration
		Engine.time_scale = lerp(target_scale, 1.0, t)
		await get_tree().process_frame
	Engine.time_scale = 1.0
