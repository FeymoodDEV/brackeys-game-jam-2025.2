@tool
extends State

## Bullet pattern used when this is active. Check BulletManager.tscn.
@export var pattern : String = "player_level_1"
## Texture applied to player sprite when this is active.
@export var texture : Texture2D = preload("res://assets/player/ship1.png")
## Shape resource applied to player CollisionShape when this is active.
@export var hitbox_shape : Shape2D = preload("res://scenes/player/level_1_hitbox.tres")
## Shape resource applied to nom dash AoE CollisionShape when this is active.
@export var nombox_shape : Shape2D = preload("res://scenes/player/level_1_nombox.tres")
## Speed when this is active.
@export var speed : float = 220.0

func _on_enter(args) -> void:
	target.gun.pattern = pattern
	target.sprite_2d.texture = texture
	target.hitbox_shape.shape = hitbox_shape
	target.nombox_shape.shape = nombox_shape
	target.speed = speed
	
