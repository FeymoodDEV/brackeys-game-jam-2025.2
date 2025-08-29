extends GPUParticles2D

# Sorry.
@onready var player: PlayerController = $".."


func _physics_process(delta: float) -> void:
	emitting = (player.get_movement_vector() != Vector2.ZERO)
