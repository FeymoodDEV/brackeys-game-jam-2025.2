@tool
extends State

## Time remaining before the end of the dash and return to normal movement.
var remaining_time : float
## Current velocity of the dash, reduced every tick.
var dash_velocity : float
## Direction unit vector of the dash.
var dash_vector : Vector2
var is_dashing = false;

func _ready():
	Spawning.bullet_collided_area.connect(_absorb_bullet);

func _on_enter(args) -> void:
	is_dashing = true;
	# start cooldown
	target.dash_cooldown_timer.start(target.dash_cooldown)
	# enable absorb zone
	target.nom_dash_aoe.monitoring = true 
	# render player intangible
	target.set_collision_layer_value(1, false)
	
	target.anim.play('dash')
	target.dash_vfx.global_rotation = target.velocity.angle() + deg_to_rad(90)
	
	dash_velocity = target.dash_power
	dash_vector = args.normalized() # this should be a vector2 direction
	# we normalize it again just in case but it should not be necessary
	
	print("dash_vector: %s" % dash_vector)
	remaining_time = target.dash_duration

func _on_update(_delta) -> void:
	if target.isDead: return
	# move player
	target.velocity = dash_vector * dash_velocity
	target.move_and_slide()
	
	# decelerate
	dash_velocity *= target.dash_friction
	
	# count down timer
	remaining_time -= _delta
	if remaining_time <= 0:
		if target.crosshair.hard_lock_target != null:
			change_state("Circling")
		else:
			change_state("Normal")

func _on_exit(args) -> void:
	# disable absorb zone
	target.nom_dash_aoe.monitoring = false
	# render player tangible
	target.set_collision_layer_value(1, true)
	
	# just in case...
	dash_velocity = 0
	dash_vector = Vector2.ZERO
	is_dashing = false;
	

func _absorb_bullet(area:Area2D,area_shape_index:int, bullet:Dictionary,local_shape_index:int,shared_area:Area2D) -> void:
	var rid = Spawning.shape_rids.get(shared_area.name, {}).get(local_shape_index)
	var points = bullet["props"]["absorb_points"]
	if is_dashing and area.name == "NomDashAoE":
		(target as PlayerController)._absorb_bullet(rid, points);
