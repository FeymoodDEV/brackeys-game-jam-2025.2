@tool
extends State

# despite the unclear name, this does update on physics_process, not process
func _on_update(_delta) -> void:
	var direction: Vector2 = target.get_look_relative_vector(_delta)
	target.velocity = direction * target.speed
	target.move_and_slide()
