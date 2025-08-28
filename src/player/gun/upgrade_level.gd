@tool
extends State

const path = GameConfig.player_sprites_dir;
const coll_path = GameConfig.player_colliders_dir;

## Bullet pattern used when this is active. Check BulletManager.tscn.
@export var pattern : String = "player_level_1"
## Texture applied to player sprite when this is active.
@export var texture : Texture2D = preload(path+"ship1.png")
## Shape resource applied to player CollisionShape when this is active.
@export var hitbox_shape : Shape2D = preload(coll_path+"level_1_hitbox.tres")
## Shape resource applied to nom dash AoE CollisionShape when this is active.
@export var nombox_shape : Shape2D = preload(coll_path+"level_1_nombox.tres")
## Speed when this is active.
@export var speed : float = 220.0

## List of thrusters sprites.
@onready var thruster_sprites = get_children().filter(func(x): return x.is_in_group(&"thrusters"))
# This is kind of crap, but it's fine enough for working on all the desired nodes
# without preventing us from adding other nodes.

func _on_enter(args) -> void:
	# Apply new variables.
	target.gun.pattern = pattern
	target.sprite_2d.texture = texture
	target.hitbox_shape.shape = hitbox_shape
	target.nombox_shape.shape = nombox_shape
	target.speed = speed
	
	# Show thrusters
	for x in thruster_sprites: x.visible = true

# I hate that I'm mixing concerns here but I can't fall into another spiral of
# doubting my decisions right now kgjsdkjgnsdf
func _process(delta: float) -> void:
	if status == ACTIVE: # is this state active?
		var movement_vector : Vector2 = target.get_movement_vector()
		if movement_vector != Vector2.ZERO:
			for x in thruster_sprites:
				x.rotation = target.look_direction.angle()
				x.animation = &"move"
		else:
			for x in thruster_sprites:
				x.animation = &"end"


func _on_exit(args) -> void:
	# Hide thrusters 
	thruster_sprites.map(func(x: AnimatedSprite2D): x.visible = false)
