extends CharacterBody2D
class_name PlayerController

#region movement_variables
@export var speed: float = 220.0
@export var accel: float = 1500.0
@export var friction: float = 2000.0
var look_direction : Vector2
#endregion

#region Dash variables
@onready var dash_cooldown_timer: Timer = $DashCooldownTimer
@export var dash_cooldown : float = 3.0
@export var dash_power : float = 100.0
@export var dash_duration : float = 0.5
@export var dash_friction : float = 10.0
#endregion

func _physics_process(delta: float) -> void:
	# Get look direction and rotate node accordingly
	look_direction = get_mouse_vector().normalized();
	self.rotation = look_direction.angle();
	
	handle_shooting()

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

func handle_shooting() -> void:
	if cooldown_timer.is_stopped():
		shoot(get_global_mouse_position())
		cooldown_timer.start()

func shoot(to_world: Vector2) -> void:
	if bullets_per_shot <= 0:
		return

	var spread_angle: float = spread_angle_multiplier * (bullets_per_shot - 1)

	var base_dir: Vector2 = (to_world - global_position).normalized()
	var base_angle: float = base_dir.angle()

	var step_angle: float = 0.0
	if bullets_per_shot > 1:
		step_angle = deg_to_rad(spread_angle) / (bullets_per_shot - 1)

	var start_angle: float = base_angle - deg_to_rad(spread_angle) / 2

	for i: int in range(bullets_per_shot):
		var bullet: Bullet = bullet_scene.instantiate()
		bullet.data = bullet_data
		bullet.global_position = global_position
		bullet.shooter = self

		var angle: float = start_angle + step_angle * i
		bullet.rotation = angle

		get_tree().current_scene.add_child(bullet)

func apply_damage(damage: int, knockback: float, global_position: Vector2, direction: Vector2):
	print('Player was hit')
