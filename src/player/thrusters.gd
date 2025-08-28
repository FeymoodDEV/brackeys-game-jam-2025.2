extends Node2D

@onready var thruster_sprites = get_children()#.filter(func(x): return x.is_in_group(&"thrusters"))
@export var upgrade_state : State

func _ready() -> void:
	upgrade_state.state_entered.connect(func(x): visible = true)
	upgrade_state.state_exited.connect(func(x): visible = false)

# I hate that I'm mixing concerns here but I can't fall into another spiral of
# doubting my decisions right now kgjsdkjgnsdf
func _process(delta: float) -> void:
	var movement_vector : Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if movement_vector != Vector2.ZERO:
		for x : AnimatedSprite2D in thruster_sprites:
			x.rotation = movement_vector.angle() + PI
			if x.animation != &"move":
				x.play(&"move")
	else:
		for x: AnimatedSprite2D in thruster_sprites:
			if x.animation != &"end":
				x.play(&"end")

#func show_thrusters() -> void:
	#for x in thruster_sprites: x.visible = true
#
#func hide_thrusters() -> void:
	#for x in thruster_sprites: x.visible = false
