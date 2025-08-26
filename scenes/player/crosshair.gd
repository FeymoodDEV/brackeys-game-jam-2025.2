extends Node2D
## Crosshair that follows the mouse cursor.
## Handles selecting targets for lock-on.
## This does not handle actually aiming, which is currently on the player
## controller itself. 

@onready var soft_lock_reticle: Node2D = $SoftLockReticle
@onready var hard_lock_reticle: Node2D = $HardLockReticle

signal hard_lock_changed
signal hard_lock_removed


## All nodes currently in the selectable area.
var targetables : Array[Node2D] = []
## Current soft lock target
var soft_lock_target : Node2D = null
# Current hard lock target
var hard_lock_target : Node2D = null


func _ready() -> void:
	top_level = true

func _process(delta: float) -> void:
	global_position = get_global_mouse_position()

# Because things only move on physics ticks, we don't need to get closest every 
# process.
func _physics_process(delta: float) -> void:
	# Handle soft lock
	if Input.is_action_just_pressed("lock_on") and hard_lock_target:
		remove_hard_lock()
	
	if Input.is_action_just_pressed("lock_on") and soft_lock_target:
		hard_lock()
	
	var closest := get_closest_targetable()
	if closest == null: # if no targetables
		if soft_lock_target: # and we had a soft lock before
			# recall soft lock reticle
			soft_lock_target = null
			soft_lock_reticle.reparent(self)
			soft_lock_reticle.visible = false
	elif closest != soft_lock_target: # if closest has changed
		# send reticle over there
		soft_lock_target = closest 
		soft_lock_reticle.reparent(soft_lock_target)
		soft_lock_reticle.visible = true
		soft_lock_reticle.position = Vector2.ZERO

# This area should only be detecting collisions from layer 5, so there should
# be no need for a check. If this doesn't work out later, use a group instead
func _on_lock_on_target_area_body_entered(body: Node2D) -> void:
	if body != hard_lock_target:
		targetables.append(body)


func _on_lock_on_target_area_body_exited(body: Node2D) -> void:
	targetables.remove_at(targetables.find(body))


# TODO
func hard_lock() -> void:
	# change soft lock to hard lock
	hard_lock_target = soft_lock_target
	targetables.remove_at(targetables.find(soft_lock_target))
	
	# recall soft lock reticle
	# TODO: deduplicate
	soft_lock_target = null
	soft_lock_reticle.reparent(self)
	soft_lock_reticle.visible = false
	
	# send hard lock over
	hard_lock_reticle.reparent(hard_lock_target)
	hard_lock_reticle.visible = true
	hard_lock_reticle.position = Vector2.ZERO
	
	# refresh targetables list
	# bit of a bandaid fix: if we don't do this, the last hard lock target will not be added to the 
	# targetable list until it leaves and reenters the zone
	targetables = $LockOnTargetArea.get_overlapping_bodies()
	targetables.remove_at(targetables.find(hard_lock_target))
	
	hard_lock_changed.emit()

## Remove the hard lock and recall the reticle.
## Connected to VisibleOnScreenNotifier2D.screen_exited()
func remove_hard_lock() -> void:
	hard_lock_target = null
	hard_lock_reticle.reparent(self)
	hard_lock_reticle.visible = false
	
	hard_lock_removed.emit()


func get_closest_targetable() -> Node2D:
	if targetables.size() <= 0: 
		return null
		
	var distances := targetables.map(func(x): return abs(get_global_mouse_position() - x.global_position))
	var idx = distances.find(distances.min())
	return targetables[idx]
	
	#var distances := targetables
	#distances.sort_custom(func(x): abs(self.global_position - x.global_position))
	#return distances[-1]
