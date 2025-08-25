@tool
extends State

# despite the unclear name, this does update on physics_process, not process
func _on_update(_delta) -> void:
	var direction: Vector2 = target.get_look_relative_vector()
	target.velocity = direction * target.speed
	target.move_and_slide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("nom_dash") and target.dash_cooldown_timer.is_stopped():
		change_state("NomDash", target.get_look_relative_vector())
