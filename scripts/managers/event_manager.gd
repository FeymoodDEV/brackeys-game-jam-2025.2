extends Node

signal player_spawned(path)
signal player_setup(dictionary)

signal menu_loaded;
signal game_scene_loaded;
signal game_paused;

signal health_changed(new_health)
signal boss_health_changed(new_health)
signal boss_spawned(bossData)
signal progress_changed(new_xp)

func _ready():
	game_paused.connect(_on_game_paused)
	
func _on_game_paused():
	get_tree().paused = true;
	
func _on_game_unpaused():
	get_tree().paused = false;
