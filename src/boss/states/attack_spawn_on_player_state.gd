@tool
extends State

@export var next_boss_state: State
@export var attack_scene: PackedScene

@export var attack_amount: int = 5
@export var attack_spawn_speed: float = 0.2
@export var attack_spawn_delay: float = 1

var attacks_left_to_spawn: int
var player: PlayerController

func _ready():
	player = get_tree().get_first_node_in_group('player')

func _on_enter(args) -> void:
	attacks_left_to_spawn = attack_amount
	add_timer("spawn_attack", attack_spawn_delay)
	target.switch_stage.connect(_on_switch_stage)

func _on_timeout(_name: String) -> void:
	match _name:
		"spawn_attack":
			var angle = randf() * TAU   # random angle (0 → 2π)
			var distance = randf_range(10.0, 50.0) # between 100 and 300 px
			var offset = Vector2(cos(angle), sin(angle)) * distance
			var spawn_pos = player.global_position + offset
			
			var attack_instance = attack_scene.instantiate()
			attack_instance.global_position = spawn_pos
			target.get_parent().add_child(attack_instance)
			
			
			attacks_left_to_spawn -= 1
			if attacks_left_to_spawn > 0:
				add_timer("spawn_attack", attack_spawn_speed)
			else:
				change_state(next_boss_state.name)

func _on_switch_stage():
	remove_active_state(self)
	exit()
	disabled = true
