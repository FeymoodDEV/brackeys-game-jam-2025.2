extends Resource
class_name EnemyData

@export_group("Gameplay")
@export var speed: float = 600.0
@export var patterns: Array[String];

@export_group("Visuals")
@export var texture: Texture2D
@export var scale: float = 1.0

@export_group("Effects")
@export var death_vfx: PackedScene;
