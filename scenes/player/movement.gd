@tool
extends State


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("dbg_normal"):
		change_state("Normal")
	if event.is_action_pressed("dbg_circling"):
		change_state("Circling")
