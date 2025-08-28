extends Node2D

@onready var player_node = $Player;

func _ready():
	deferred_ready.call_deferred();
	
func deferred_ready():
	player_node.reparent(get_parent())
	EventManager.player_spawned.emit(player_node.get_path())
