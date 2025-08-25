extends Node2D
class_name Enemy

@export var rotation_speed: float = 3.0   # radians per second
@onready var player: Node2D = get_node("/root/Main/Player") # adjust path to your player
@onready var gun: Node2D = $Gun
@onready var cooldown_timer: Timer = $Timer

@export var pattern: PatternLine = PatternLine.new()

func _ready():
	pattern.offset = Vector2(40,40)
	pattern.bullet = "1"
	pattern.nbr = 5
	
	Spawning.new_pattern("one",pattern)

func _physics_process(delta: float) -> void:
	if cooldown_timer.is_stopped():
		shoot()
		cooldown_timer.start()

func shoot():
	Spawning.spawn({
		"position":gun.global_position,
		"rotation":gun.rotation,
		"source_node": get_node("/root/Main")
		}, "circle")
