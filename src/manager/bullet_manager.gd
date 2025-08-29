extends Node2D

@onready var player_node = $Player;

func _ready():
	EventManager.game_started.connect(_on_game_started);
	
func _on_game_started():
	Spawning.create_pool("PBullet", "0", 2000, false);
	Spawning.create_pool("ChocBullet", "1", 1000);
	Spawning.create_pool("SugarBullet", "1", 2000);

	player_node.add_to_group("Player");
	
