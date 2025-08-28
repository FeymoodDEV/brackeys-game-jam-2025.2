extends Node2D

@export var rotation_speed: float = 3.0   # radians per second
@onready var player: Node2D = get_node("/root/Main/Player") # adjust path to your player

func _process(delta):
	if not player:
		return

	var dir: Vector2 = (player.global_position - global_position).normalized()
	var target_angle: float = dir.angle()
	
	rotation = lerp_angle(rotation, target_angle, rotation_speed * delta)
