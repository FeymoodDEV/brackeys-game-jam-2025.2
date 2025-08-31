@tool
extends State

@export var next_boss_state: State
@export var state_duration: float = 10
@export var patterns: Array[BossPatternData]

var active: bool = false

func _on_enter(args) -> void:
	active = true
	
	add_timer("go_to_next_state", state_duration)
	
	for pattern in patterns:
		add_timer(pattern.name, pattern.start_after)

func _on_exit(args) -> void:
	active = false

func _on_timeout(_name: String) -> void:
	if not active: return
	
	if _name == "go_to_next_state":
		change_state(next_boss_state.name)
		return
		
	for pattern in patterns:
		if pattern.name == _name:
			target.anim.play('attack')
			await target.anim.animation_finished
			target.spawn_pattern(pattern.name)
			add_timer(pattern.name, pattern.repeat_after)
