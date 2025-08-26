extends BuHBulletNode
class_name BulletNode

@export var data: BulletData
@onready var sprite: Sprite2D = $Sprite2D

var direction: Vector2 = Vector2.RIGHT
var time_alive: float = 0.0
var remaining_pierce: int = 0
var trail: Node;

func _ready() -> void:
	body_shape_entered.connect(_on_body_shape_entered);
	
	remaining_pierce = data.pierce_count
	
	if data.texture:
		sprite.texture = data.texture
		sprite.scale = Vector2.ONE * data.scale
		
	if data.trail_vfx:
		trail = $trail;

		
	if ID == "": push_warning("ID missing in node "+String(get_path()))
#	assert(ID != "", "ID missing in node "+String(get_path()))
	name = ID
#	if not get_parent() is InstanceLister:
#		push_warning("Warning: node "+String(get_path())+" must be child of an InstanceLister in order to be accessible for spawning")
	
	for child in get_children():
		if child.name in ignore_children: continue
		
		if child is AnimatedSprite2D:
			var entry:Dictionary
			entry["enabled"] = child.visible
			entry["position"] = child.position + child.offset
			entry["rotation"] = child.rotation
			entry["scale"] = child.scale
			entry["skew"] = child.skew
			entry["texture"] = child.sprite_frames
			if child.flip_h == true or child.flip_v == true:
				push_warning("Use negative scale to flip a BulletNode's sprite, not flip_h or flip_v")
#			entry["flip"] = Vector2(FLIP[int(child.flip_h)],FLIP[int(child.flip_v)])
			entry["modulate"] = child.modulate
			textures.append(entry)
	
#	single_texture = (textures.size() == 1)
#	if single_texture:
#		var entry:Dictionary = textures[0]
#		draw_set_transform_matrix(Transform2D(entry["rotation"], entry["scale"], entry["skew"], entry["position"]))
	
	area_shape_entered.connect(Spawning.bullet_collide_area.bind(self))
	body_shape_entered.connect(Spawning.bullet_collide_body.bind(self))
	
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

func _physics_process(delta: float) -> void:
	pass
	

func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if "apply_damage" not in body: 
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

	Spawning.delete_bullet(self);
