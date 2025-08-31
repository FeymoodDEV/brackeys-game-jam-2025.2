#class_name ScoreManager
extends Node

var score : int = 0:
	set(new_score):
		score = max(0, new_score)
		EventManager.score_changed.emit(score, multiplier)

var multiplier : int = 1:
	set(new_multiplier):
		multiplier = max(1, new_multiplier)
		EventManager.score_changed.emit(score, multiplier)

var previous_score : int = 0

func _ready() -> void:
	EventManager.enemy_died.connect(_on_enemy_died)
	EventManager.level_started.connect(_on_level_started)
	EventManager.level_restart.connect(_on_level_restart)
	EventManager.game_ended.connect(reset)

func _on_level_started():
	# Save score when level starts
	previous_score = score

func _on_level_restart():
	# Restore score to previous
	score = previous_score

func reset():
	score = 0
	multiplier = 1.0
	previous_score = 0
	EventManager.score_changed.emit(score, multiplier)

func _on_enemy_died(value):
	score += value * multiplier
