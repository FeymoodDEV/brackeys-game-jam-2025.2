@tool
extends State

@export var state_duration: float = 10
@export var pattern_spawn_delay: float = 1
@export var pattern: String = "chocolate_spin_pattern"

func _on_enter(args) -> void:
	add_timer(pattern, pattern_spawn_delay)
	add_timer("go_to_next_state", state_duration)

func _on_timeout(_name: String) -> void:
	match _name:
		pattern:
			target.spawn_pattern(pattern, Vector2.ZERO, 0)
			target.spawn_pattern(pattern, Vector2.ZERO, 45)
			target.spawn_pattern(pattern, Vector2.ZERO, 90)
			target.spawn_pattern(pattern, Vector2.ZERO, 135)
			target.spawn_pattern(pattern, Vector2.ZERO, 180)
			target.spawn_pattern(pattern, Vector2.ZERO, 225)

		"go_to_next_state":
			change_to_next()
