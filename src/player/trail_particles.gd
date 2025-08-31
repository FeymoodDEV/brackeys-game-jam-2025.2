extends GPUParticles2D

# Sorry.
@onready var player;

func _ready():
	player = get_parent().get_parent();

func _physics_process(delta: float) -> void:
	if player is PlayerController:
		emitting = (player.get_movement_vector() != Vector2.ZERO)
