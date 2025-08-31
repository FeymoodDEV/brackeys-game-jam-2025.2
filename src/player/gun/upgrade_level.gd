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
## Per upgrade level multiplier to absorb points gained.
@export var absorb_pts_multiplier : float = 1.0
## Score multiplier when this is active. Should be higher with higher levels.
@export var score_multiplier : int = 1

func _on_enter(args) -> void:
	# Apply new variables.
	target.gun.pattern = pattern
	target.sprite_2d.texture = texture
	target.hitbox_shape.shape = hitbox_shape
	target.nombox_shape.shape = nombox_shape
	target.absorb_pts_multiplier = absorb_pts_multiplier
	#target.speed = speed
	ScoreManager.multiplier = score_multiplier # could be a source of bugs later sorry
