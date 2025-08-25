extends Area2D
class_name Bullet

@export var data: BulletData
@onready var sprite: Sprite2D = $Sprite

var shooter: Node = null
var direction: Vector2 = Vector2.RIGHT
var time_alive: float = 0.0
var remaining_pierce: int = 0

func _ready() -> void:
	if !data: return
	
	remaining_pierce = data.pierce_count
	
	if data.texture:
		sprite.texture = data.texture
		scale = Vector2.ONE * data.scale

	if data.trail_vfx:
		var trail: Node = data.trail_vfx.instantiate()
		add_child(trail)

func _physics_process(delta: float) -> void:
	# forward vector from rotation (to the right = 0 radians in Godot)
	var forward: Vector2 = Vector2.RIGHT.rotated(rotation)
	position += forward * data.speed * delta

	time_alive += delta
	if time_alive >= data.lifetime:
		queue_free()

func _on_body_entered(body: Node) -> void:
	if "apply_damage" not in body or body == shooter: 
		return
	else: 
		body.apply_damage(data.damage, data.knockback, global_position, direction)
	
	if data.hit_vfx:
		var hit_vfx: GPUParticles2D = data.hit_vfx.instantiate()
		hit_vfx.global_position = position
		hit_vfx.emitting = true
		hit_vfx.connect("finished", Callable(hit_vfx, "queue_free"))
		get_parent().add_child(hit_vfx)

	if data.hit_sfx:
		var audio: AudioStreamPlayer2D = AudioStreamPlayer2D.new()
		audio.stream = data.hit_sfx
		audio.global_position = global_position
		get_parent().add_child(audio)
		audio.play()

	if remaining_pierce > 0:
		remaining_pierce -= 1
	else:
		queue_free()
