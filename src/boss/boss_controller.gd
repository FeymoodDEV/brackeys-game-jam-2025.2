extends CharacterBody2D
class_name BossControler

@export var data: BossData

var health: float

func _ready():
	health = data.health
	EventManager.emit_signal("boss_spawned", data)

func spawn_pattern(pattern: String, pos_offset: Vector2 = Vector2.ZERO, rot_offset: int = 0) -> void:
	Spawning.spawn({
		"position": global_position + pos_offset, 
		"rotation": rotation + rot_offset, 
		"source_node": get_parent()
		}, pattern, "1")
		
func apply_damage(damage: int, knockback: float, global_position: Vector2, direction: Vector2) -> void:
	health -= damage;
	
	EventManager.emit_signal("boss_health_changed", health)
	
	if health <= 0:
		queue_free.call_deferred()
