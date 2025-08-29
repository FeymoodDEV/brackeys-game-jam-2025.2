extends CharacterBody2D
class_name PlayerController

#region movement_variables
@export_category("Movement")
## Speed of the player in units per tick.
@export var speed: float = 220.0
## Acceleration of the player in units per tick. Unused.
@export var accel: float = 1500.0
## Friction of the player in units per tick. Unused.
@export var friction: float = 2000.0
## Look vector of the ship. Either follows the mouse or the hard lock target.
## This determines where we shoot and affects movement in circling mode.
var look_direction : Vector2
#endregion

#region Dash variables
@export_category("Dash")
@onready var dash_cooldown_timer: Timer = $DashCooldownTimer
@onready var nom_dash_aoe: Area2D = $NomDashAoE

## Time in seconds for dash to be available again after use.
@export var dash_cooldown : float = 3.0
## Length of dash initial movement vector in units.
@export var dash_power : float = 100.0
## Duration of a dash in seconds.
@export var dash_duration : float = 0.5
## Velocity lost per tick during dash in units per tick.
@export var dash_friction : float = 10.0
#endregion

#region Targeting variables
@onready var crosshair: Node2D = $Crosshair
#endregion

#region Upgrade variables
## Emitted when the upgrade level goes up or down.
signal upgrade_level_changed

## Current upgrade level. 
var current_level : int = 0
## Progress towards upgrading. Increases when absorbing bullets with nom dash,
## consumed by  when leveling up
var absorb_pts : int = 0 :
	set(val):
		absorb_pts = val
		
		var pending_signal : bool = false
		while current_level < max_level and absorb_pts >= upgrade_threshold:
			absorb_pts -= upgrade_threshold
			current_level += 1
			pending_signal = true
		if pending_signal: upgrade_level_changed.emit()

## Points required for upgrade. Mind: this is constant. To make the cost increase
## for higher levels, we'll use multipliers.
@export_category("Upgrading")
@export var upgrade_threshold : int = 10
## Max upgrade level. Starts at zero!!!
@export var max_level : int = 2

@onready var sprite_2d: Sprite2D = $ShipSprite
@onready var nombox_shape: CollisionShape2D = $NomDashAoE/NomboxShape
@onready var hitbox_shape: CollisionShape2D = $HitboxShape
@onready var gun: Node2D = $Gun
#endregion

#region Health
@export_category("Health")
var health: float
@export var max_health: float = 100
@export var death_vfx: PackedScene = preload("res://prefabs/particles/explode_vfx.tscn")
#endregion

func _ready():
	health = max_health
	
	EventManager.player_setup.emit({
		"progress_max_value": 100, 
		"health_max_value": max_health,
	})
	EventManager.player_spawned.emit(get_path())
	
	# States run their on_enter behaviour before _ready, which causes a problem
	# when they try to mutate player properties.
	# The solution in this case is to have an initial state with no behaviour
	# (PreInit) that we switch away from on _ready.
	$Root/Upgrade.change_state("Level1")

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("level_down"):
		# TODO: add VFX, and potentially a transitory state
		level_down()

## Returns currently inputted direction.
func get_movement_vector() -> Vector2:
	return Input.get_vector("move_left", "move_right", "move_up", "move_down")

## Returns vector from this node to the mouse.
func get_mouse_vector() -> Vector2:
	return get_global_mouse_position() - self.global_position

## Returns vector from this node to the hard lock target, or `Vector2.ZERO` if 
## there is none.
func get_hard_lock_vector() -> Vector2:
	if crosshair.hard_lock_target != null:
		return crosshair.hard_lock_target.global_position - self.global_position
	else:
		printerr("ERROR: Tried to get_hard_lock_vector without hard lock engaged")
		return Vector2.INF

## Returns the input vector rotated in relation to the look direction.
func get_look_relative_vector() -> Vector2:
	var input_vector = get_movement_vector()

	# We can actually just rotate the vector 
	var look_relative = input_vector.rotated(look_direction.angle())
	return look_relative

## Reduces health by `damage` and signals the change. 
func apply_damage(damage: int, knockback: float, global_position: Vector2, direction: Vector2):
	health -= damage
	EventManager.emit_signal("health_changed", health)
	
	if health <= 0:
		die()
	
	# TODO: implement knockback.

signal player_dead

func die() -> void:
	print("DIE")
	var vfx = death_vfx.instantiate()
	add_child(vfx)
	vfx.top_level = true
	vfx.global_position = global_position
	vfx.play(&"default")
	player_dead.emit(player_dead)
	

## Reduces upgrade level by one. 
func level_down() -> void:
	if current_level > 0:
		current_level -= 1
		upgrade_level_changed.emit()
