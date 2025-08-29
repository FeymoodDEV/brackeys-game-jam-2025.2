extends CanvasLayer
class_name PlayerUI

@onready var timer: Timer = $Timer
@onready var countdown_label: Label = $Countdown
@onready var health_bar: ProgressBar = $HealthBar
@onready var boss_health_bar: ProgressBar = $BossHealthBar
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var boss_label: Label = $BossName

func _ready() -> void:
	EventManager.health_changed.connect(_on_health_changed)
	EventManager.boss_health_changed.connect(_on_boss_health_changed)
	EventManager.setup_boss_ui.connect(_on_boss_spawned)
	EventManager.progress_changed.connect(_on_progress_changed)
	EventManager.player_setup.connect(_on_setup)
	
	timer.start()
	timer.timeout.connect(_on_timer_timeout)

func _on_timer_timeout():
	EventManager.emit_signal("spawn_boss")

func dispaly_timer() -> Array:
	var time_left: float = timer.time_left
	var minute: Variant = floor(time_left / 60)
	var second: int = int(time_left) % 60
	
	return [minute, second]

func _on_setup(dict: Dictionary) -> void:
	progress_bar.value = dict.progress_max_value
	progress_bar.max_value = dict.progress_max_value
	health_bar.value = dict.health_max_value
	health_bar.max_value = dict.health_max_value
	
func _process(delta) -> void:
	countdown_label.text = "%02d:%02d" % dispaly_timer()

func _on_health_changed(health: float) -> void:
	health_bar.value = health

func _on_boss_health_changed(health: float) -> void:
	boss_health_bar.value = health
	
func _on_boss_spawned(max_health: float, boss_name: String) -> void:
	boss_health_bar.visible = true
	boss_label.visible = true
	countdown_label.visible = false
	
	boss_health_bar.max_value = max_health
	boss_health_bar.value = max_health
	boss_label.text = boss_name
	
func _on_progress_changed(new_value: float) -> void:
	progress_bar.value = new_value
