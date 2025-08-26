extends Node2D

@export var ROTATION_SPEED : float = 10

func _process(delta: float) -> void:
	rotate(deg_to_rad(ROTATION_SPEED))
