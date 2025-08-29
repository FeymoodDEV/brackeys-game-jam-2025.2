@tool
extends State

@export var next_boss_state: State
@export var minion_data: EnemyData

@export var minion_amount: int = 5
@export var minion_spawn_speed: float = 0.2
@export var minion_spawn_delay: float = 1

@onready var enemy_scene: PackedScene = preload("res://prefabs/enemies/basic_enemy.tscn")

var minions_left_to_spawn: int

func _on_enter(args) -> void:
	minions_left_to_spawn = minion_amount
	add_timer("spawn_minion", minion_spawn_delay)

func _on_timeout(_name: String) -> void:
	match _name:
		"spawn_minion":
			var minion_instance: EnemyController = enemy_scene.instantiate()
			minion_instance.global_position = target.global_position
			minion_instance.enemy_data = minion_data
			minion_instance.player = get_tree().get_first_node_in_group('player')
			target.get_parent().add_child(minion_instance)
			
			minions_left_to_spawn -= 1
			if minions_left_to_spawn > 0:
				add_timer("spawn_minion", minion_spawn_speed)
			else:
				change_state(next_boss_state.name)
