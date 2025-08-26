@tool
extends State

var remaining_time : float
var dash_velocity : float
var dash_vector : Vector2

func _on_enter(args) -> void:
	target.dash_cooldown_timer.start(target.dash_cooldown)
	
	dash_velocity = target.dash_power
	dash_vector = args.normalized() # this should be a vector2 direction
	# we normalize it again just in case but it should not be necessary
	
	print("dash_vector: %s" % dash_vector)
	remaining_time = target.dash_duration

func _on_update(_delta) -> void:
	# move player
	target.velocity = dash_vector * dash_velocity
	target.move_and_slide()
	
	# decelerate
	dash_velocity *= target.dash_friction
	
	# count down timer
	remaining_time -= _delta
	if remaining_time <= 0:
		change_state("Normal")

func _on_exit(args) -> void:
	# just in case...
	dash_velocity = 0
	dash_vector = Vector2.ZERO
