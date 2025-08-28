extends Resource
class_name BossData

@export var name: String = "Jeff"

@export_group("Gameplay")
@export var speed: float = 600.0
@export var health: float = 2000.0;
@export var damage: float = 10.0;
@export var xp_worth: float = 10.0;

@export_group("Visuals")
@export var sprite: Texture2D
@export var color_palette: ColorPalette;
@export var modulate_color: Color;
@export var scale: float = 1.0

@export_group("Effects")
@export var death_vfx: PackedScene;
