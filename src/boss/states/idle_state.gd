@tool
extends State

func _on_enter(args) -> void:
	add_timer("stop_idle", 1)
	
func _on_timeout(_name: String) -> void:
	match _name:
		"stop_idle":
			change_state("State")
