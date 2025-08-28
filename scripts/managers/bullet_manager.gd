extends Node2D

@onready var player_node = $Player;

func _ready():
	deferred_ready.call_deferred();
	
func deferred_ready():
	Spawning.create_pool("PBullet", "0", 200, true);
	Spawning.create_pool("EBullet", "1", 200, true);
	player_node.reparent(get_parent())
