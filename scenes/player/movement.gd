@tool
extends State

func _input(event: InputEvent) -> void:
	# Debug : change between states on a keypress
	if event.is_action_pressed("dbg_normal"):
		change_state("Normal")
	if event.is_action_pressed("dbg_circling"):
		change_state("Circling")
	if event.is_action_pressed("pause_menu"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE;

func _on_crosshair_hard_lock_changed() -> void:
	print("SIGNAL: hard_lock_changed")
	if target.crosshair.hard_lock_target != null:
		if not is_active("Circling"):
			change_state("Circling")
	else: 
		change_state("Normal")
