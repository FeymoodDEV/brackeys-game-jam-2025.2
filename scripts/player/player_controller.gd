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
#endregion

func _physics_process(delta: float) -> void:
	# Get look direction and rotate node accordingly
	look_direction = get_mouse_vector().normalized();
	self.rotation = look_direction.angle();
	
	#if not is_dashing and Input.is_action_just_pressed("nom_dash") and dash_cooldown_timer.is_stopped():
		#is_dashing = true
	#
	#if is_dashing:
		#handle_dash(delta)
	#
	#if not is_dashing:
		#velocity = get_movement_vector(delta) * speed

func get_mouse_vector() -> Vector2:
	return get_global_mouse_position() - self.global_position

func get_look_relative_vector(delta: float) -> Vector2:
	var input_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down");

	var look_relative = input_vector.rotated(look_direction.angle() + (PI/2))
	return look_relative
