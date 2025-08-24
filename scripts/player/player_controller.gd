extends CharacterBody2D
class_name PlayerController

@export var speed: float = 220.0
@export var accel: float = 1500.0
@export var friction: float = 2000.0

func _physics_process(delta: float) -> void:
	look_at(get_global_mouse_position())
	handle_movement(delta)

func handle_movement(delta: float) -> void:
	var input_dir: Vector2 = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down")  - Input.get_action_strength("move_up")
	).normalized()

	var target_vel: Vector2 = input_dir * speed

	if input_dir != Vector2.ZERO:
		velocity = velocity.move_toward(target_vel, accel * delta)
	else:
		if velocity.length() > 0.0:
			var drop: float = friction * delta
			velocity = velocity.move_toward(Vector2.ZERO, drop)
		else:
			velocity = Vector2.ZERO

	move_and_slide()
