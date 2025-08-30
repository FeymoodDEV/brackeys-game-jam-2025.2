class_name ModifierHandler
extends Node
## This class can later be made to handle different modifiers.

func update(target):
	var children : Array = get_children()#.filter(func(x): return x is Modifier)
	
	if children.any(func(x): return x is InvulnModifier):
		target.is_invulnerable = true
		
	else:
		target.is_invulnerable = false
