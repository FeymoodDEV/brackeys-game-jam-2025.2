class_name ModifierHandler
extends Node
## This class can later be made to handle different modifiers.

func update(target: PlayerController):
	var children : Array = get_children()#.filter(func(x): return x is Modifier)
	
	if children.any(func(x): return x is InvulnModifier):
		target.is_invulnerable = true
		target.animation_player.queue("invulnerable")
	else:
		target.is_invulnerable = false
		if target.animation_player.current_animation == "invulnerable":
			target.animation_player.stop()
