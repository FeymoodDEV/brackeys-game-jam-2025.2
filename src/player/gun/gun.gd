extends Node2D

## If false, cannot shoot.
@export var enabled : bool = true
#@export var bullets_per_shot: int = 1
## Shot cooldown in seconds
@export var shot_cooldown : float = 0.1 

@onready var shot_cooldown_timer: Timer = $ShotTimer

## String identifier of the bullet pattern to shoot, as defined in the 
## BulletManager scene.
var pattern : String = "player_level_one"

const spread_angle_multiplier: int = 10

func _ready() -> void:
	shot_cooldown_timer.wait_time = shot_cooldown
	shot_cooldown_timer.stop()

func _physics_process(delta: float) -> void:
	# TODO: instead of this, look into PROCESS_MODE.
	if enabled and Input.is_action_pressed("shoot"):
		if shot_cooldown_timer.is_stopped():
			shoot()
			shot_cooldown_timer.start(shot_cooldown)


func shoot() -> void:
	#var spawn_pos = $SpawnPoint.global_position;
	#var rot = global_rotation
	#var node = get_parent().get_parent()
	get_parent().audio.shooting.pitch_scale = randf_range(0.9, 1.1)
	get_parent().audio.shooting.play()
	Spawning.spawn(self, pattern, "0")
	
	
