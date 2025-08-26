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

@onready var crosshair: Node2D = $Crosshair


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

func get_movement_vector() -> Vector2:
	return Input.get_vector("move_left", "move_right", "move_up", "move_down")

## Returns vector from this node to the mouse.
func get_mouse_vector() -> Vector2:
	return get_global_mouse_position() - self.global_position

## Returns the input vector rotated in relation to the look direction.
func get_look_relative_vector() -> Vector2:
	var input_vector = get_movement_vector()

	# We can actually just rotate the vector 
	var look_relative = input_vector.rotated(look_direction.angle())
	return look_relative
