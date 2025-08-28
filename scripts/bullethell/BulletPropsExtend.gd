@tool

extends BulletProps
class_name BulletPropsExtend

@export var texture: Texture;

@export_group("Gameplay")
@export var pierce_count: int = 0
@export var knockback: float = 0.0
@export var absorb_points: int = 1

@export_group("Visuals")
@export var sprite_scale: float = 0.25;
@export var hit_vfx: PackedScene
@export var hit_sfx: AudioStream
@export var trail_vfx: PackedScene

var direction: Vector2 = Vector2.RIGHT
var time_alive: float = 0.0
var remaining_pierce: int = 0
var trail_particles: GPUParticles2D;

var enabled = false;
