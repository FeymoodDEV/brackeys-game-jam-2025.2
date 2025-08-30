extends Area2D
class_name MilkLaser

@onready var collision: CollisionShape2D = $CollisionShape2D
@export var duration: float = 1.00
@export var damage: float = 10
@onready var timer: Timer = $Timer
	

func _on_animation_animation_finished():
	$animation.hide()
	$Laser.show()
	monitoring = true
	timer.start()
	
func _on_body_entered(body):
	if body.has_method("apply_damage"):
		body.apply_damage(damage);

func _on_timer_timeout():
	queue_free()
