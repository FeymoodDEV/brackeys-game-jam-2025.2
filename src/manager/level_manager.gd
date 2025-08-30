extends Node2D
class_name LevelManager

var player: PlayerController
var chosen: Vector2i

@export var level_scenes: Array[PackedScene];
@export var levels: Array[LevelData];
@export var level_scene: PackedScene;
var level_node: Node2D;

## map width and height references cell count
var map_time: float = 10;
var map_width: int = 40
var map_height: int = 30

var cell_size: int = 32 #px

## so blocks are being placed in clusters rather scattered around
var cluster_chance: float = 0.01
var cluster_size: int = 4

var border_scene: PackedScene

var block_scenes: Array[PackedScene]
var enemy_scene: PackedScene = preload("res://prefabs/enemies/basic_enemy.tscn")
var enemy_datas: Array[EnemyData]
var background_tiles: Array[Texture]

var boss_instance: Node2D
var next_level: Level;

var current_level: LevelData;
var level_index = 0;

var grid: Array = []
var rng: RandomNumberGenerator = RandomNumberGenerator.new()

@onready var timer: Timer = $LevelTimer;

func _input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		EventManager.level_scene_instanced.emit(next_level);

func _on_level_scene_instanced(data: LevelData):
	if not data:
		return;
	
	# Load all level data into LevelManager
	map_time = data.map_time;
	map_height = data.map_height;
	map_width = data.map_width;
	timer.wait_time = data.map_time;
	
	cluster_chance = data.cluster_chance;
	cluster_size = data.cluster_size;
	border_scene = data.border_scene;
	
	block_scenes = data.block_scenes;
	enemy_scene = data.enemy_scene;
	enemy_datas = data.enemy_datas;
	background_tiles = data.background_tiles;
	
	boss_instance = data.boss_scene.instantiate();
	
	current_level = data;	
	
	_level_ready();
	pass

func _on_player_ready(player_path):
	player = get_node(player_path);
	assert(player);
	pass

func _on_game_started():	
	level_index = 2
	
	level_node = level_scene.instantiate();
	add_child(level_node);
	
	EventManager.level_scene_instanced.emit(levels[level_index]);
	
	player.respawn()
	pass

func _on_game_ended():
	$BG.hide();
	pass	

func _on_level_started(map_time):
	player.reparent(level_node);
	$BG.show();
	pass
	
func _on_level_ended():
	# If there are still more levels to play load the next level
	if level_index < level_scenes.size():
		next_level = level_scenes[level_index].instantiate() as Level;	
		EventManager.level_scene_instanced.emit(next_level);
		level_index += 1;
	else:
		player.reparent(self);
		level_node.queue_free();
		EventManager.game_ended.emit();

	pass

func _enter_tree():
	EventManager.player_ready.connect(_on_player_ready)
	EventManager.player_killed.connect(_on_player_killed)
	
	EventManager.game_started.connect(_on_game_started)
	EventManager.game_ended.connect(_on_game_ended);
	
	EventManager.level_scene_instanced.connect(_on_level_scene_instanced);
	EventManager.level_started.connect(_on_level_started)
	EventManager.level_ended.connect(_on_level_ended)
	EventManager.spawn_boss.connect(_on_boss_spawn)
	EventManager.boss_killed.connect(_on_boss_killed)
	
	EventManager.main_menu.connect(_on_main_menu)
	
func _ready():		
	timer.timeout.connect(EventManager.spawn_boss.emit)
	$BG.hide();

func _level_ready() -> void:
	$BG.texture = background_tiles[randi() % background_tiles.size()]
	$BG.show();
	
	create_empty_grid()
	generate_level()
	spawn_enemies()
	place_player()
	
	timer.wait_time = map_time
	timer.one_shot = true;
	
	timer.start();
	
	EventManager.level_started.emit(map_time);

func _on_level_timer_timeout():
	pass

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
	level_node.add_child.call_deferred(block)

	grid[y][x] = block  # mark as occupied

## UNFINISHED AND UNSURE ON HOW I WANT TO SPAWN ENEMIES
func spawn_enemies() -> void:
	for y: int in range(map_height):
		for x: int in range(map_width):
			if grid[y][x] == null:
				if rng.randi_range(1, 30) != 1: continue
				var enemy: EnemyController = enemy_scene.instantiate()
				
				enemy.position = Vector2(x * cell_size, y * cell_size);
				enemy.enemy_data = enemy_datas[randi() % enemy_datas.size()]
				enemy.player = player;
				level_node.add_child.call_deferred(enemy)
				
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
	assert(boss_instance, "setup Boss scene");
	
	boss_instance.global_position = Vector2(chosen.x * cell_size, chosen.y * cell_size)
	level_node.add_child(boss_instance)
	
	Spawning.clear_all_bullets()
	
	for enemy: EnemyController in get_tree().get_nodes_in_group("enemy"):
		enemy.die()
	for block: Block in get_tree().get_nodes_in_group("block"):
		block.die()

func _on_boss_killed() -> void:
	await slow_motion(0.2, 1.0, 0.5)  # target_scale, duration, hold_time
	Spawning.clear_all_bullets()
	EventManager.level_ended.emit();

func _on_player_killed() -> void:
	await slow_motion(0.2, 0.5, 0.2)
	EventManager.show_death_screen.emit()
	
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

func _on_main_menu():
	player.reparent(self);
	level_node.queue_free();
	clear_everything()
	EventManager.game_ended.emit();
	

func clear_everything():
	Spawning.clear_all_bullets()
