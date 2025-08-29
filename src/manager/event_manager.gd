extends Node

signal player_ready(path)
signal player_setup(dictionary)

signal menu_loaded;
signal game_started;
signal level_scene_instanced(level_scene: Node2D);
signal level_started;

signal game_paused;

signal health_changed(new_health)
signal boss_health_changed(new_health)
signal spawn_boss()
signal setup_boss_ui(boss_max_health, boss_name)
signal progress_changed(new_xp)
signal boss_killed()

func _ready():
	game_paused.connect(_on_game_paused)
	
func _on_game_paused():
	get_tree().paused = true;
	
func _on_game_unpaused():
	get_tree().paused = false;
