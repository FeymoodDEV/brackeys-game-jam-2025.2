extends CharacterBody2D
class_name PlayerController

#region movement_variables
@export var speed: float = 220.0
@export var accel: float = 1500.0
@export var friction: float = 2000.0
#endregion

#region shooting_variables
@export var bullet_scene: PackedScene = preload("res://scenes/bullets/bullet.tscn")
@export var bullet_data: BulletData = preload("res://resources/bullets/first_bullet.tres")
@onready var cooldown_timer: Timer = $Timer
@export var bullets_per_shot: int = 1
const spread_angle_multiplier: int = 10
#endregion

func _physics_process(delta: float) -> void:
	#look_at(get_global_mouse_position())
	handle_movement(delta)
	
	handle_shooting()

func handle_movement(delta: float) -> void:
	# CybrNight: Calculate normalized look_direction vector
	var mouse_pos: Vector2 = get_global_mouse_position();
	var look_direction: Vector2 = (mouse_pos - self.global_position).normalized();
	
	self.rotation = look_direction.angle();
	
	var input_dir: Vector2 = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down")  - Input.get_action_strength("move_up")
	).normalized()
	
	var input_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down");
	var direction = Vector2.ZERO;

	var target_vel: Vector2 = input_dir * speed
	
	# CybrNight: Calculate the relative left and right vectors
	var left: Vector2 = look_direction.rotated(deg_to_rad(90));
	var right: Vector2 = look_direction.rotated(deg_to_rad(-90));

	# CybrNight: Apply each physics componenet separately
	direction += input_vector.y * -look_direction;
	direction += input_vector.x * left;
	
	if direction.length() > 0:
		direction = direction.normalized()

	# Apply movement
	velocity = direction * speed
	move_and_slide()

func handle_shooting() -> void:
	if cooldown_timer.is_stopped():
		shoot(get_global_mouse_position())
		cooldown_timer.start()

func shoot(to_world: Vector2) -> void:
	if bullets_per_shot <= 0:
		return
	
	## 1 bullet = no angle
	## 3 bullet = 20 degree angle
	## 5 bullet = 40 degree angle
	var spread_angle: float = spread_angle_multiplier * (bullets_per_shot - 1)
	
	var base_dir: Vector2 = (to_world - global_position).normalized()
	var base_angle: float = base_dir.angle()  # in radians
	
	# calculate angle between bullets
	var step_angle: float = 0.0
	if bullets_per_shot > 1:
		step_angle = deg_to_rad(spread_angle) / (bullets_per_shot - 1)
	
	var start_angle: float = base_angle - deg_to_rad(spread_angle) / 2
	
	for i: int in range(bullets_per_shot):
		var bullet: Area2D = bullet_scene.instantiate()
		bullet.data = bullet_data
		bullet.global_position = global_position

		var angle: float = start_angle + step_angle * i
		bullet.direction = Vector2(cos(angle), sin(angle))

		get_tree().current_scene.add_child(bullet)
