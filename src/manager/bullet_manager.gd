extends Node2D

@onready var player_node = $Player;

func _ready():
	player_node.add_to_group("Player");

	_deferred_ready.call_deferred();
	
func _deferred_ready():
	Spawning.create_pool("PBullet", "0", 2000);
	Spawning.create_pool("ChocBullet", "1", 2000);
	Spawning.create_pool("SugarBullet", "1", 2000);
	
func _process(delta):
	pass
	

	

	
