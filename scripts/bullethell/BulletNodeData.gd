@tool
extends Resource
class_name BulletNodeData

@export_group("Gameplay")
@export var speed: float = 600.0
@export var damage: float = 10.0
@export var lifetime: float = 1.5
@export var pierce_count: int = 0
@export var knockback: float = 0.0

@export_group("Visuals")
@export var texture: Texture2D
@export var scale: float = 1.0

@export_group("Effects")
@export var hit_vfx: PackedScene
@export var trail_vfx: PackedScene
@export var hit_sfx: AudioStream
