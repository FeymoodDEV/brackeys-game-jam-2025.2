class_name InvulnModifier
extends ConstantModifier

signal invuln_modifier_timed_out

var remaining_time : float

func _init(time: float) -> void:
	remaining_time = time

func _physics_process(delta: float) -> void:
	remaining_time -= delta
	if remaining_time <= 0:
		invuln_modifier_timed_out.emit()
		queue_free()

#func apply(target: PlayerController):
	#target.is_invulnerable = true
#
#func remove(target):
	#target.is_invulnerable = false
