@tool
extends State



func _input(event: InputEvent) -> void:
	# Debug : change between states on a keypress
	if event.is_action_pressed("dbg_normal"):
		change_state("Normal")
	if event.is_action_pressed("dbg_circling"):
		change_state("Circling")


func _on_crosshair_hard_lock_changed() -> void:
	print("SIGNAL EMITTED")
	if not is_active("Circling"):
		change_state("Circling")


func _on_crosshair_hard_lock_removed() -> void:
	print("SIGNAL EMITTEDsdqzdsq")
	change_state("Normal")
	
