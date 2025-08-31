extends Node2D

@export var packed_game_scene: PackedScene;

@export var play_btn: Button;
@export var options_btn: Button;
@export var quit_btn: Button;

@export var options_back_btn: Button;
@export var intro_play_btn: Button;

@export var bgm: AudioStream = preload("res://assets/sounds/music/Biscuit_Intro.ogg")

@onready var main_layer: CanvasLayer = $MainLayer;
@onready var options_layer: CanvasLayer = $OptionsLayer;
@onready var intro_layer: CanvasLayer = $IntroTutorial;
@onready var end_screen_layer: CanvasLayer = $EndScreenLayer

@export var master_vol_slider: HSlider;
@export var music_vol_slider: HSlider;
@export var sfx_vol_slider: HSlider;

var master_bus;
var music_bus;
var sfx_bus;

var game_scene: Node2D;

func set_main_menu_active(value: bool = true):	
	propagate_call("set_process", [value])
	propagate_call("set_physics_process", [value])
	propagate_call("set_process_input", [value])
	if value:
		show();
	else:
		hide();
		
func _on_master_vol_slider_changed(value: float):
	AudioServer.set_bus_volume_db(master_bus, value)
	pass

func _on_music_vol_slider_changed(value: float):
	AudioServer.set_bus_volume_db(music_bus, value)
	pass
	
func _on_sfx_vol_slider_changed(value: float):
	AudioServer.set_bus_volume_db(sfx_bus, value);
	pass

func set_end_screen_active(value: bool = true):
	end_screen_layer.propagate_call("set_process", [value])
	end_screen_layer.propagate_call("set_physics_process", [value])
	end_screen_layer.propagate_call("set_process_input", [value])
	if value:
		end_screen_layer.show();
	else:
		end_screen_layer.hide();

func _ready():
	master_bus = AudioServer.get_bus_index("Master");
	music_bus = AudioServer.get_bus_index("Music");
	sfx_bus = AudioServer.get_bus_index("SFX");
	
	AudioServer.set_bus_volume_db(master_bus, master_vol_slider.value);
	AudioServer.set_bus_volume_db(music_bus, music_vol_slider.value);
	AudioServer.set_bus_volume_db(sfx_bus, sfx_vol_slider.value);
	
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE;
	BgmManager.change_bgm(bgm)
	
	
	play_btn.pressed.connect(_on_play_btn_pressed)
	options_btn.pressed.connect(_on_options_btn_pressed);
	quit_btn.pressed.connect(_on_exit_button_pressed);
	options_back_btn.pressed.connect(_on_options_back_btn_pressed);
	intro_play_btn.pressed.connect(_on_intro_play_btn_pressed);
	
	EventManager.game_started.connect(_on_game_started);
	EventManager.game_ended.connect(_on_game_ended)
	EventManager.game_won.connect(_on_game_won);
	main_layer.show();
	options_layer.hide();
	intro_layer.hide();
	play_btn.grab_focus();

func _on_game_started():
	$Background.hide();
	set_main_menu_active(false);
	main_layer.propagate_call("hide");

func _on_game_won():
	set_main_menu_active(false)
	set_end_screen_active(true)
	end_screen_layer.propagate_call("show")

func _on_game_ended():
	set_main_menu_active(true)
	main_layer.propagate_call("show")

func _on_play_btn_pressed():
	main_layer.hide();
	intro_layer.show();
	pass
	
func _on_intro_play_btn_pressed():
	intro_layer.hide();
	EventManager.game_started.emit();
	pass
	
func _on_options_btn_pressed():
	options_layer.show();
	main_layer.hide();
	pass
	
func _on_options_back_btn_pressed():
	main_layer.show();
	options_layer.hide();
	pass
	
func _on_exit_button_pressed():
	get_tree().quit(1);


func _on_end_screen_btn_pressed() -> void:
	set_end_screen_active(false)
	end_screen_layer.propagate_call("hide")
	EventManager.game_ended.emit()
