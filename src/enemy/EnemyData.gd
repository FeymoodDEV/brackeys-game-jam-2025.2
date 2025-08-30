extends Resource
class_name EnemyData

@export_group("Gameplay")
@export var pattern: String = "line";
@export var speed: float = 600.0
@export var health: float = 100.0;
@export var damage: float = 10.0;
@export var xp_worth: float = 10.0;

@export_group("Visuals")
@export var sprite: Texture2D
@export var color_palette: ColorPalette;
@export var modulate_color: Color;
@export var scale: float = 1.0

@export_group("Effects")
@export var damage_sfx: AudioStream = preload("res://assets/sounds/enemy/damaged.ogg")
@export var death_vfx: PackedScene;
@export var death_sfx: AudioStream = preload("res://assets/sounds/enemy/dead.ogg")
@export var shoot_sfx: AudioStream = preload("res://assets/sounds/enemy/shoot.ogg")
