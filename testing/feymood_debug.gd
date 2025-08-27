extends Node2D

func _process(delta):
	$CanvasLayer/FPS.text = str(Engine.get_frames_per_second())+" FPS\n"+str(Spawning.poolBullets.size())
	$CanvasLayer/AbsorbAmount.text = str($Player.absorb_amount)
