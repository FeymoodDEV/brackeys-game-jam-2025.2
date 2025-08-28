extends Node2D

@onready var player_node = $Player;

func _ready():
	deferred_ready.call_deferred();
	
func deferred_ready():
	Spawning.create_pool("PBullet", "0", 2000, false);
	Spawning.create_pool("ChocBullet", "1", 1000);
	Spawning.create_pool("SugarBullet", "1", 2000);
	
	player_node.add_to_group("Player");
	player_node.reparent(get_parent())
	
