@tool
extends State

# despite the unclear name, this does update on physics_process, not process
func _on_update(_delta) -> void:
	if target.isDead: return
	# Get look direction and rotate node accordingly
	var look_vector = target.get_hard_lock_vector();
	target.look_direction = look_vector if look_vector != Vector2.INF else target.get_mouse_vector();
	target.rotation = target.look_direction.angle();
	
	# Handle movement
	var direction: Vector2 = target.get_look_relative_vector().rotated((PI/2))
	target.velocity = direction * target.speed
	target.move_and_slide()
	
	if Input.is_action_just_pressed("nom_dash") and target.dash_cooldown_timer.is_stopped():
		if direction != Vector2.ZERO:
			change_state("NomDash", direction)

#func _input(event: InputEvent) -> void:
	#if event.is_action_pressed("nom_dash") and target.dash_cooldown_timer.is_stopped():
		#var direction = target.get_look_relative_vector()
		#if direction != Vector2.ZERO:
			#change_state("NomDash", direction)
