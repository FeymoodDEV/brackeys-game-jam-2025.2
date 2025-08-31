extends Node2D

@onready var player_node = $Player;

func _ready():
	player_node.add_to_group("Player");

	_deferred_ready.call_deferred();

func _deferred_ready():
	Spawning.spawn({"position": -Vector2.INF, "rotation": 0, "source_node": self}, "player_level_1", "0")
	Spawning.spawn({"position": -Vector2.INF, "rotation": 0, "source_node": self}, "player_level_2", "0")
	Spawning.spawn({"position": -Vector2.INF, "rotation": 0, "source_node": self}, "player_level_3", "0")
	Spawning.spawn({"position": -Vector2.INF, "rotation": 0, "source_node": self}, "enemy_one", "1")
	Spawning.spawn({"position": -Vector2.INF, "rotation": 0, "source_node": self}, "enemy_circle", "1")
	Spawning.spawn({"position": -Vector2.INF, "rotation": 0, "source_node": self}, "enemy_circle_sugar", "1")
	Spawning.spawn({"position": -Vector2.INF, "rotation": 0, "source_node": self}, "sugar_trigger", "1")
	Spawning.spawn({"position": -Vector2.INF, "rotation": 0, "source_node": self}, "sugar_one_big_pattern", "1")
	Spawning.spawn({"position": -Vector2.INF, "rotation": 0, "source_node": self}, "EggCircleReturning", "1")
	
	
	Spawning.create_pool("PBullet", "0", 2000);
	Spawning.create_pool("PBullet2", "0", 2000);
	Spawning.create_pool("ChocBullet", "1", 2000);
	Spawning.create_pool("SugarBullet", "1", 2000);
	Spawning.create_pool("SugarBulletBig", "1", 2000);
	Spawning.create_pool("SugarTriggerBullet", "1", 2000);
	Spawning.create_pool("EggBullet", "1", 2000);
	
	Spawning.clear_all_bullets();

func _process(delta):
	pass
