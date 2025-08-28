extends BuHBulletNode
class_name BulletNode

@export_group("Gameplay")
@export var speed: float = 600.0
@export var damage: float = 10.0
@export var lifetime: float = 1.5
@export var pierce_count: int = 0
@export var knockback: float = 0.0
@export var absorb_value: int = 1

@export_group("Visuals")
@export var bullet_texture: Texture2D
@export var sprite_scale: float = 0.25;
@export var hit_vfx: PackedScene
@export var hit_sfx: AudioStream
@export var trail_vfx: PackedScene

var direction: Vector2 = Vector2.RIGHT
var time_alive: float = 0.0
var remaining_pierce: int = 0
@onready var trail: GPUParticles2D = $GPUParticles2D;

var trail_particles: GPUParticles2D;

var enabled = false;

func _draw():
	if not enabled:
		return;
	
	# Define the position and size of the texture
	var size = bullet_texture.get_size() * sprite_scale;
	
	# Draw the texture with scaling
	draw_texture_rect(bullet_texture, Rect2(size/2, size), false)
	
	pass
	
func _process(delta):
	queue_redraw();

func _ready() -> void:
	# Connect signals
	body_shape_entered.connect(_on_body_shape_entered);
	
	remaining_pierce = pierce_count
		
		
	if ID == "": push_warning("ID missing in node "+String(get_path()))
#	assert(ID != "", "ID missing in node "+String(get_path()))
	name = ID
#	if not get_parent() is InstanceLister:
#		push_warning("Warning: node "+String(get_path())+" must be child of an InstanceLister in order to be accessible for spawning")
	

	
#	single_texture = (textures.size() == 1)
#	if single_texture:
#		var entry:Dictionary = textures[0]
#		draw_set_transform_matrix(Transform2D(entry["rotation"], entry["scale"], entry["skew"], entry["position"]))

	base_scale = scale
			
#		if child is CollisionShape2D:
#			var entry:Dictionary
#			entry["enabled"] = !child.disabled
#			entry["position"] = child.position + child.offset
#			entry["rotation"] = child.rotation
#			entry["scale"] = child.scale
#			entry["skew"] = child.skew
#			entry["shape"] = child.shape
#			collisions.append(entry)
#
#		if child is CollisionPolygon2D: #TODO
#			var entry:Dictionary
#			entry["enabled"] = !child.disabled
#			entry["position"] = child.position + child.offset
#			entry["rotation"] = child.rotation
#			entry["scale"] = child.scale
#			entry["skew"] = child.skew
#			entry["polygon"] = child.polygon
#			collisions.append(entry)

func _on_spawned():		
	enabled = true;
	if is_instance_valid(trail):
		trail.show();

func _on_deleted():
	enabled = false;
	if is_instance_valid(trail):
		trail.queue_free.call_deferred();

func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if not body.has_method("apply_damage"):
		#Spawning.delete_bullet(self);
		return
	else: 
		body.apply_damage(damage, knockback, global_position, direction)
	
	if hit_vfx:
		var hit_vfx: GPUParticles2D = hit_vfx.instantiate()
		hit_vfx.global_position = global_position
		hit_vfx.emitting = true
		hit_vfx.finished.connect.bind(hit_vfx.queue_free.call_deferred);
		get_parent().add_child(hit_vfx)

	if hit_sfx:
		var audio: AudioStreamPlayer2D = AudioStreamPlayer2D.new()
		audio.stream = hit_sfx
		audio.global_position = global_position
		get_parent().add_child(audio)
		audio.play()
	
	remaining_pierce -= 1;
