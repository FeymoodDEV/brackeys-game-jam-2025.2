extends Node2D

@export var enabled : bool = true
@export var bullet_scene: PackedScene = preload("res://scenes/bullets/bullet.tscn")
#@export var bullets_per_shot: int = 1
## Shot cooldown in seconds
@export var shot_cooldown : float = 0.1 

@onready var shot_cooldown_timer: Timer = $ShotTimer

const spread_angle_multiplier: int = 10

func _ready() -> void:
	shot_cooldown_timer.wait_time = shot_cooldown
	shot_cooldown_timer.stop()

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("shoot"):
		if shot_cooldown_timer.is_stopped():
			shoot()
			shot_cooldown_timer.start(shot_cooldown)

func shoot() -> void:
	#region Pre-BHU code
	# Kept in case it's useful, but expects to be on the Player node script. Beware
	
	#if bullets_per_shot <= 0:
		#return
	#
	### 1 bullet = no angle
	### 3 bullet = 20 degree angle
	### 5 bullet = 40 degree angle
	#var spread_angle: float = spread_angle_multiplier * (bullets_per_shot - 1)
	#
	#var base_dir: Vector2 = (to_world - global_position).normalized()
	#var base_angle: float = base_dir.angle()  # in radians
	#
	## calculate angle between bullets
	#var step_angle: float = 0.0
	#if bullets_per_shot > 1:
		#step_angle = deg_to_rad(spread_angle) / (bullets_per_shot - 1)
	#
	#var start_angle: float = base_angle - deg_to_rad(spread_angle) / 2
	#
	#for i: int in range(bullets_per_shot):
		#var bullet: Area2D = bullet_scene.instantiate()
		#bullet.data = bullet_data
		#bullet.global_position = global_position
#
		#var angle: float = start_angle + step_angle * i
		#bullet.direction = Vector2(cos(angle), sin(angle))
	#endregion
	
	var spawn_pos = $SpawnPoint.global_position;
	
	var rot = global_rotation
	var node = get_parent().get_parent();


	Spawning.spawn({"position": spawn_pos, "rotation": rot, "source_node": node}, "player_one", "0")
	
	
