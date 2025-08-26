extends CharacterBody2D
class_name EnemyController

const PLAYER_COLLISION_LAYER = 2
const WALL_COLLISION_LAYER = 0

@export var wander_radius: float = 350.0  # max distance from spawn
@export var speed: float = 180.0
@export var ray_length: float = 30.0

var spawn_position: Vector2
var current_direction: Vector2 = Vector2.ZERO
var player: PlayerController = null
var move_timer: float = 0.0

var shoot_counter = 0;

func _ready() -> void:
	spawn_position = global_position
	player = get_tree().get_first_node_in_group("player")
	
	pick_new_direction()

func _physics_process(delta: float) -> void:
	handle_movement(delta)

func handle_movement(delta: float) -> void:
	if path_is_blocked(current_direction):
		pick_new_direction()
	else:
		move_timer -= delta
		if move_timer <= 0.0 or current_direction == Vector2.ZERO:
			pick_new_direction()
			move_timer = randf_range(0.5, 1.5)
	
	velocity = current_direction * speed
	
	shoot_counter += delta;
	if shoot_counter > 1:
		var spawn_pos = global_position;
		var rot = global_rotation
		var node = get_parent();

		#Spawning.spawn({"position": spawn_pos, "rotation": rot, "source_node": node}, "line")
		Spawning.spawn(self, "line")
		shoot_counter = 0;
	move_and_slide()

func path_is_blocked(dir: Vector2) -> bool:
	if dir == Vector2.ZERO:
		return false
		
	var from: Vector2 = global_position
	var to: Vector2 = from + dir.normalized() * ray_length

	var query: PhysicsRayQueryParameters2D = PhysicsRayQueryParameters2D.create(from, to)
	query.exclude = [self]
	
	query.collision_mask = (1 << WALL_COLLISION_LAYER) | (1 << PLAYER_COLLISION_LAYER)

	var hit: Dictionary = get_world_2d().direct_space_state.intersect_ray(query)
	return not hit.is_empty()

func pick_new_direction() -> void:
	var tries: int = 8
	var new_direction: Vector2 = Vector2.ZERO

	for i: int in range(tries):
		new_direction = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized()
		var new_pos: Vector2 = global_position + new_direction * ray_length

		if not path_is_blocked(new_direction) and new_pos.distance_to(spawn_position) <= wander_radius:
			current_direction = new_direction
			return

 	#fallback: move back toward spawn
	current_direction = (spawn_position - global_position).normalized()

func apply_damage(damage: int, knockback: float, global_position: Vector2, direction: Vector2) -> void:
	queue_free()
