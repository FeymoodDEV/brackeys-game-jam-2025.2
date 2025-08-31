#class_name ScoreManager
extends Node

func _ready() -> void:
	EventManager.enemy_died.connect(_on_enemy_died)

var score : int = 0:
	set(new_score):
		score = max(0,new_score)
		EventManager.score_changed.emit(score, multiplier)

var multiplier : float = 1.0:
	set(new_multiplier):
		multiplier = max(1 ,new_multiplier)
		EventManager.score_changed.emit(score, multiplier)

func reset():
	score = 0
	multiplier = 1.0
	EventManager.score_changed.emit(score, multiplier)

func _on_enemy_died(value):
	score += value
