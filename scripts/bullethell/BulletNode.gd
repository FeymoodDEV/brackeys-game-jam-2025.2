extends BuHBulletNode
class_name BulletNode

#region BulletNodeData
@export var data: BulletNodeData
#endregion

#region Graphics onready vars
@onready var sprite: Sprite2D = $Sprite2D
@onready var trail: GPUParticles2D = $GPUParticles2D;
#endregion

#region BulletNodeData vars
var direction: Vector2 = Vector2.RIGHT
var time_alive: float = 0.0
var remaining_pierce: int = 0
var hit_vfx;
#endregion

var trail_particles: GPUParticles2D;

func _ready() -> void:
	assert(data);
	
	# Connect signals
	body_shape_entered.connect(_on_body_shape_entered);
	
	# Load data from BulletNodeData into local vars
	remaining_pierce = data.pierce_count
	
	trail_particles = data.trail_vfx.instantiate();
	
	if data.texture:
		sprite.texture = data.texture
		sprite.scale = Vector2.ONE * data.scale
		
	if GameConfig.SHOW_TRAILS:
		trail_particles.emitting = true;
		add_child(trail_particles)
		trail_particles = null;


		
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
	if is_instance_valid(trail):
		trail.show();

func _on_deleted():
		if is_instance_valid(trail):
			trail.queue_free.call_deferred();

func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if not body.has_method("apply_damage"):
		Spawning.delete_bullet(self);
		return
	else: 
		body.apply_damage(data.damage, data.knockback, global_position, direction)
	
	if data.hit_vfx:
		var hit_vfx: GPUParticles2D = data.hit_vfx.instantiate()
		hit_vfx.global_position = global_position
		hit_vfx.emitting = true
		get_parent().add_child(hit_vfx)

	if data.hit_sfx:
		var audio: AudioStreamPlayer2D = AudioStreamPlayer2D.new()
		audio.stream = data.hit_sfx
		audio.global_position = global_position
		get_parent().add_child(audio)
		audio.play()
	
	remaining_pierce -= 1;
	
	
	Spawning.delete_bullet(self);
