extends Node2D

@export var enabled : bool = true
@export var bullet_scene: PackedScene = preload("res://scenes/bullets/bullet.tscn")
@export var shot_cooldown : float = 0.2

@onready var l_muzzle: Marker2D = $LMuzzle
@onready var r_muzzle: Marker2D = $RMuzzle
@onready var shot_cooldown_timer: Timer = $ShotCooldownTimer

func _physics_process(delta: float) -> void:
	if enabled and Input.is_action_pressed("shoot"):
		if shot_cooldown_timer.is_stopped():
			shoot()
			shot_cooldown_timer.start(shot_cooldown)

func shoot() -> void:
	# TODO:
	pass
