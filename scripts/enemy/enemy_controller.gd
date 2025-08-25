extends CharacterBody2D
class_name EnemyController

var spawn_position: Vector2
@export var wander_radius: float = 350.0  # max distance from spawn

@export var speed: float = 180.0
@export var wander_time: Vector2 = Vector2(1.0, 3.0)
@export var ray_length: float = 50.0
@export var vision_range: float = 300.0

var current_direction: Vector2 = Vector2.ZERO
var state := "wander"
var change_timer: float = 0.0
var player: PlayerController = null

@export var preferred_range: float = 100.0  # desired distance from player
@export var range_tolerance: float = 130.0   # wiggle room
@export var strafe_time: Vector2 = Vector2(20, 20) # how long to strafe before switching

var strafe_dir: Vector2 = Vector2.ZERO
var strafe_timer: float = 0.0

func _ready() -> void:
	spawn_position = global_position
	pick_new_direction()
	player = get_tree().get_first_node_in_group("player") # mark player with "player" group

func _physics_process(delta: float) -> void:
	do_chase(delta)
	
	velocity = current_direction * speed
	move_and_slide()

func do_chase(delta: float) -> void:
	if !player: return
	
	var to_player := player.global_position - global_position
	var dist := to_player.length()
	var dir_to_player := to_player.normalized()
	
	if is_blocked(current_direction):
		pick_new_direction()
	else:
		strafe_timer -= delta
		if strafe_timer <= 0.0 or current_direction == Vector2.ZERO:
			pick_new_direction()
			
			# pick a new strafe direction (perpendicular-ish to player)
			#var perp := Vector2(-dir_to_player.y, dir_to_player.x)
			#if randf() < 0.5:
				#perp = -perp
				
			#strafe_dir = (perp + Vector2(randf_range(-0.3, 0.3), randf_range(-0.3, 0.3))).normalized()
			#strafe_timer = randf_range(strafe_time.x, strafe_time.y)
			
			strafe_timer = 1

func is_blocked(dir: Vector2) -> bool:
	if dir == Vector2.ZERO:
		return false
	var from := global_position
	var to := from + dir.normalized() * ray_length

	var query := PhysicsRayQueryParameters2D.create(from, to)
	query.exclude = [self]
	# Only collide with walls (layer 1) and player (layer 3), for example
	query.collision_mask = (1 << 0) | (1 << 2)   # layers are 0-indexed in code

	var hit := get_world_2d().direct_space_state.intersect_ray(query)
	return not hit.is_empty()

func pick_new_direction() -> void:
	var tries := 8
	var dir := Vector2.ZERO

	for i in range(tries):
		dir = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized()
		var new_pos = global_position + dir * ray_length
		
		if not is_blocked(dir) and new_pos.distance_to(spawn_position) <= wander_radius:
			current_direction = dir
			change_timer = randf_range(wander_time.x, wander_time.y)
			return

 	#fallback: move back toward spawn
	current_direction = (spawn_position - global_position).normalized()
	change_timer = randf_range(wander_time.x, wander_time.y)

func apply_damage(damage: int, knockback: float, global_position: Vector2, direction: Vector2):
	queue_free()
