@tool
extends State

var move_timer;

func _on_update(_delta) -> void:
	var current_direction = target.current_direction;
	
	if target.path_is_blocked(current_direction):
		target.pick_new_direction()
	else:
		target.move_timer -= _delta
		if target.move_timer <= 0.0 or target.current_direction == Vector2.ZERO:
			target.pick_new_direction()
			move_timer = randf_range(0.5, 1.5)
	
	target.velocity = current_direction * target.speed
	
	target.shoot_counter += _delta;
	if target.player and target.player.global_position.distance_to(target.global_position) < 250:
		if target.shoot_counter > 1.5:
			var spawn_pos = target.global_position;
			var rot = target.global_rotation

			Spawning.spawn({"position": spawn_pos, "rotation": rot, "source_node": target.node}, target.pattern, "1")
			#Spawning.spawn(self, "line")
			target.shoot_counter = 0;
	target.move_and_slide()
