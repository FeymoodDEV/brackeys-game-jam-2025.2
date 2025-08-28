extends Node
class_name Block

@export var data: BlockData

var health: int
var isDestructable: bool = true
@onready var sprite: Sprite2D = $Sprite
@onready var anim: AnimationPlayer = $AnimationPlayer

func _ready():
	health = data.health
	isDestructable = data.isDestructable
	sprite.texture = data.texture

# This exists to ensure nodes attached to this one can avoid being freed alongside
# this node (ex: target reticles). Sorry.
signal freeing
func safe_queue_free() -> void:
	freeing.emit()
	queue_free.call_deferred()

func apply_damage(damage: int, knockback: float, global_position: Vector2, direction: Vector2):
	pass
	anim.play("hit")
	
	if !isDestructable: return
	
	health -= 1
	if health <= 0:
		safe_queue_free()
