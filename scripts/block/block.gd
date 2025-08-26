extends Node
class_name Block

#func _ready() -> void:
	#self.add_to_group("targetable")

func apply_damage(damage: int, knockback: float, global_position: Vector2, direction: Vector2):
	print('Block was hit')
