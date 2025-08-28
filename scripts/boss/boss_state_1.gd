@tool
extends State

@export var cooldown: float = 1

#func _on_enter(args) -> void:
	#Spawning.create_pool("boss_bullet", "1", 90, true);
	#var timer: Timer = add_timer("timer",cooldown)
	#timer.one_shot = false

func _on_timeout(_name: String) -> void:
	match _name:
		"timer":
			print(target)
			Spawning.spawn({
				"position": target.global_position, 
				"rotation": target.rotation, 
				"source_node": target.get_parent()
				}, "boss_pattern_1", "1")
