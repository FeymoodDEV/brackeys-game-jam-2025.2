extends CharacterBody2D
class_name EnemyController

const PLAYER_COLLISION_LAYER = 2
const WALL_COLLISION_LAYER = 0

@export var enemy_data: EnemyData;

var spawn_position: Vector2
var current_direction: Vector2 = Vector2.ZERO
var player: PlayerController = null
var move_timer: float = 0.0
var health: float = 100.0;
var damage: float = 10.0;
var xp_worth: int = 10.0;
@onready var node = get_parent();

var shoot_counter = 0;

#region EnemyData-Variables
@onready var icon: Sprite2D = $Icon;
@onready var anim_player: AnimationPlayer = $AnimationPlayer;
var wander_radius: float = 350.0  # max distance from spawn
var speed: float = 180.0
var ray_length: float = 30.0
var pattern: String = "line";

#endregion

func _ready() -> void:
	assert(enemy_data, "EnemyData resource is null!");
	EventManager.player_spawned.connect(_on_player_spawned)
	
	# Load enemy data into local variables
	if enemy_data.sprite:
		icon.texture = enemy_data.sprite;
		icon.scale *= enemy_data.scale;
	icon.self_modulate = enemy_data.modulate_color;
	
	speed = enemy_data.speed;
	health = enemy_data.health;
	damage = enemy_data.damage;
	xp_worth = enemy_data.xp_worth;
	
	spawn_position = global_position
	
	pattern = enemy_data.pattern;
	
	pick_new_direction()

func _physics_process(delta: float) -> void:
	handle_movement(delta)

# This exists to ensure nodes attached to this one can avoid being freed alongside
# this node (ex: target reticles). Sorry.
signal freeing
func safe_queue_free() -> void:
	freeing.emit()
	queue_free.call_deferred()

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
	if player and player.global_position.distance_to(global_position) < 250:
		if shoot_counter > 1.5:
			var spawn_pos = global_position;
			var rot = global_rotation
			Spawning.spawn(self, pattern, "1")
			#Spawning.spawn(self, "line")
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
	health -= damage;
	if health <= 0:
		die()

func die() -> void:
	var vfx = enemy_data.death_vfx.instantiate()
	get_tree().get_root().add_child(vfx)
	vfx.top_level = true
	vfx.global_position = global_position
	vfx.play(&"default")
	safe_queue_free()

func _on_player_spawned(path: NodePath):
	player = get_node(path)
