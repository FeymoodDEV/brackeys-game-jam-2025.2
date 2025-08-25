@tool
extends State

# despite the unclear name, this does update on physics_process, not process
func _on_update(_delta) -> void:
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down");
	target.velocity = direction * target.speed
	target.move_and_slide()
