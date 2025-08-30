@tool
extends State

@export var next_boss_state: State

@export var state_duration: float = 10
@export var pattern_spawn_delay: float = 1
@export var pattern: String = "chocolate_spin_pattern"

@export var repeat: bool = false
@export var repeat_after: float = 1

func _on_enter(args) -> void:
	target.switch_stage.connect(_on_switch_stage)
	add_timer(pattern, pattern_spawn_delay)
	if !repeat:
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
			
			if repeat: add_timer(pattern, repeat_after)

		"go_to_next_state":
			change_state(next_boss_state.name)

func _on_switch_stage():
	remove_active_state(self)
	exit()
	disabled = true
