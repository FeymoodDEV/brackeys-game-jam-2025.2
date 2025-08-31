extends Node2D

# sorryyyyy
@onready var player : PlayerController = get_parent()
@onready var moving: AudioStreamPlayer2D = $Moving
@onready var shooting: AudioStreamPlayer2D = $Shooting

func _ready():
	moving.bus = &"SFX"
	shooting.bus = &"SFX"
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player.get_movement_vector() != Vector2.ZERO:
		if not moving.playing: moving.play()
	else:
		moving.stop()
