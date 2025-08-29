class_name VFXSprite2D
extends AnimatedSprite2D

func _ready() -> void:
	animation_finished.connect(queue_free.call_deferred)
