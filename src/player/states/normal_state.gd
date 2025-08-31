@tool
extends State

# despite the unclear name, this does update on physics_process, not process
func _on_update(_delta) -> void:
	if target.isDead: return
	# Get look direction and rotate node accordingly
	target.look_direction = target.get_mouse_vector().normalized();
	target.rotation = target.look_direction.angle();
	
	# Handle movement
	var direction = target.get_movement_vector()
	target.velocity = direction * target.speed
	target.move_and_slide()
	
	if Input.is_action_just_pressed("nom_dash") and target.dash_cooldown_timer.is_stopped():
		if direction != Vector2.ZERO:
			change_state("NomDash", direction)


#func _input(event: InputEvent) -> void:
	#if event.is_action_pressed("nom_dash") and target.dash_cooldown_timer.is_stopped():
		#var direction = target.get_movement_vector()
		#print("direction: %s" % direction)
		#if direction != Vector2.ZERO:
			#change_state("NomDash", direction)
