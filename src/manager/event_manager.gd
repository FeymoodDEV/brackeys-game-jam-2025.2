extends Node

signal player_ready(path)
signal player_setup(dictionary)
signal player_killed()

signal menu_loaded;
signal game_started;

signal level_scene_instanced(level_data: LevelData);
signal level_started(map_time: float);
signal level_restart;
signal level_ended;

signal block_destroyed(position: Vector2);

signal game_paused;
signal game_ended;
signal game_won

signal health_changed(new_health)
signal progress_changed(new_xp, xp_to_level_up)

signal spawn_boss()
signal setup_boss_ui(boss_max_health, boss_name)
signal boss_killed()
signal boss_health_changed(new_health)

signal show_death_screen()

signal main_menu()

func _ready():
	game_paused.connect(_on_game_paused)
	
func _on_game_paused():
	get_tree().paused = true;
	
func _on_game_unpaused():
	get_tree().paused = false;
