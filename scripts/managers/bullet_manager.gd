extends Node2D

@onready var player_node = $Player;

func _ready():
	deferred_ready.call_deferred();
	
func deferred_ready():
	Spawning.create_pool("PBullet", "0", 200, true);
	Spawning.create_pool("ChocBullet", "1", 200, true);
	Spawning.create_pool("SugarBullet", "1", 200, true);
	
	Spawning.spawn({"position": Vector2.INF, "rotation": 0, "source_node": self}, "enemy_circle", "1")
	Spawning.spawn({"position": Vector2.INF, "rotation": 0, "source_node": self}, "player_one", "0")
	Spawning.spawn({"position": Vector2.INF, "rotation": 0, "source_node": self}, "enemy_line", "1")

	player_node.reparent(get_parent())
	
