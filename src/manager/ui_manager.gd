extends CanvasLayer
class_name PlayerUI

@onready var timer: Timer = $Timer
@onready var countdown_label: Label = $Countdown
@onready var health_bar: ProgressBar = $HealthBar

@onready var boss_health_bar: ProgressBar = $BossHealthBar
@onready var boss_label: Label = $BossName
@onready var boss_hud: TextureRect = $BossHud

@onready var progress_bar: ProgressBar = $ProgressBar
@onready var death_screen: Control = $DeathScreeen

func _ready() -> void:
	EventManager.health_changed.connect(_on_health_changed)
	EventManager.boss_health_changed.connect(_on_boss_health_changed)
	EventManager.setup_boss_ui.connect(_on_boss_spawned)
	EventManager.boss_killed.connect(_on_boss_killed)
	EventManager.progress_changed.connect(_on_progress_changed)
	EventManager.player_setup.connect(_on_setup)
	EventManager.level_started.connect(_on_level_started)
	EventManager.show_death_screen.connect(_on_show_death_screen)
	EventManager.boss_killed.connect(_on_boss_killed)
	
func _on_level_started(map_time, level_name):
	$LevelLoad/Label.text = level_name
	$LevelLoad/AnimationPlayer.play("show_level")
	
	print("LEVEL STARTED!")
	timer.wait_time = map_time;
	timer.one_shot = true;
	timer.start();

func display_timer() -> Array:
	var time_left: float = timer.time_left
	var minute: Variant = floor(time_left / 60)
	var second: int = int(time_left) % 60
	
	return [minute, second]

func _on_setup(dict: Dictionary) -> void:
	print("Setting up scenes with following values: \n%s" % str(dict))
	progress_bar.value = 0
	progress_bar.max_value = dict.progress_max_value
	health_bar.value = dict.health_max_value
	health_bar.max_value = dict.health_max_value
	boss_health_bar.hide()
	boss_label.hide()
	boss_hud.hide()
	countdown_label.show()
	
func _process(delta) -> void:
	countdown_label.text = "%02d:%02d" % display_timer();

func _on_health_changed(health: float, max_health: float) -> void:
	health_bar.max_value = max_health
	health_bar.value = health

func _on_boss_health_changed(health: float) -> void:
	boss_health_bar.value = health
	
func _on_boss_spawned(max_health: float, boss_name: String, sprite: Texture2D) -> void:
	print("Boss spawned: %s" % boss_name)
	$BossCutScene/Label.text = boss_name
	$BossCutScene/BossProfile.texture = sprite
	$BossCutScene/AnimationPlayer.play("introduction")
	
	boss_health_bar.show()
	boss_label.show()
	boss_hud.show()
	countdown_label.hide()
	
	boss_health_bar.max_value = max_health
	boss_health_bar.value = max_health
	boss_label.text = boss_name
	
func _on_boss_killed() -> void:
	boss_health_bar.hide()
	boss_label.hide()
	boss_hud.hide()
	countdown_label.show()
	print("Boss is dead, long live the boss")

func _on_progress_changed(new_value: float, xp_to_level_up: float) -> void:
	progress_bar.value = new_value
	progress_bar.max_value = xp_to_level_up

func _on_show_death_screen() -> void:
	print("Showing death screen")
	death_screen.show()
	$DeathScreeen/AnimationPlayer.play('open')

func _on_restart_pressed():
	print("Button pressed: restart")
	death_screen.hide()
	EventManager.level_restart.emit();

func _on_quit_pressed():
	print("Button pressed: quit")
	BgmManager.change_bgm(preload("res://assets/sounds/music/Biscuit_Intro.ogg"))
	death_screen.hide()
	EventManager.main_menu.emit()
