extends CanvasLayer
class_name PlayerUI

@onready var timer: Timer = $Timer
@onready var countdownLabel: Label = $Countdown
@onready var healthLabel: Label = $Label

func _ready():
	EventManager.connect("health_changed", _on_health_changed)
	timer.start()

func dispaly_timer():
	var time_left = timer.time_left
	var minute = floor(time_left / 60)
	var second = int(time_left) % 60
	return [minute, second]

func _process(delta):
	countdownLabel.text = "%02d:%02d" % dispaly_timer()

func _on_health_changed(health: float):
	healthLabel.text = str(int(health))
