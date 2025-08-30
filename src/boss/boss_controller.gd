extends CharacterBody2D
class_name BossControler

@export var boss_name: String = "Jeff"
@export var stage_1: State
@export var stage_2: State

@export_group("Gameplay")
@export var speed: float = 600.0
@export var max_health: float = 1000.0;
@export var damage: float = 10.0;
@export var xp_worth: float = 10.0;

@export_group("Visuals")
@export var sprite: Texture2D
@export var color_palette: ColorPalette;
@export var modulate_color: Color;

@export_group("Effects")
@export var death_vfx: PackedScene;

var health: float

signal switch_stage

func _ready():
	health = max_health
	EventManager.emit_signal("setup_boss_ui", max_health, boss_name)

func spawn_pattern(pattern: String, pos_offset: Vector2 = Vector2.ZERO, rot_offset: int = 0) -> void:
	Spawning.spawn({
		"position": global_position + pos_offset, 
		"rotation": rotation + rot_offset, 
		"source_node": get_parent()
		}, pattern, "1")
		
func apply_damage(damage: int, knockback: float, global_position: Vector2, direction: Vector2) -> void:
	health -= damage;
	
	EventManager.emit_signal("boss_health_changed", health)
	
	if health <= max_health / 2 and stage_2:
		switch_stage.emit()
		
		stage_2.enter()
		for c in stage_2.get_children():
			if c is State:
				c._init_status_active()
	
	if health <= 0:
		die()

func die():
	queue_free.call_deferred()
	EventManager.boss_killed.emit()
