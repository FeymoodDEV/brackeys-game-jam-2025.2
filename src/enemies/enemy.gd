extends Node2D
class_name Enemy

@export var rotation_speed: float = 3.0   # radians per second
@onready var player: Node2D = get_node("/root/Main/Player") # adjust path to your player
@onready var gun: Node2D = $Gun
@onready var cooldown_timer: Timer = $Timer

@export var pattern: PatternLine = PatternLine.new()

var p = 0

func _physics_process(delta: float) -> void:
	if cooldown_timer.is_stopped():
		shoot()
		cooldown_timer.start()

func shoot():
	var pattern_array = [
		"shape",
		"v-shape",
		"circle",
	]
	p += 1
	if p > 2 :
		p = 0
	Spawning.spawn(
		self
		, pattern_array[p])
