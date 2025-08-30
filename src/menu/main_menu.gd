extends Node2D

@export var packed_game_scene: PackedScene;

@export var play_btn: Button;
@export var help_btn: Button;
@export var quit_btn: Button;

@export var help_back_btn: Button;

@export var bgm: AudioStream = preload("res://assets/sounds/music/Biscuit_Intro.ogg")

@onready var main_layer: CanvasLayer = $MainLayer;
@onready var options_layer: CanvasLayer = $OptionsLayer;
@onready var end_screen_layer: CanvasLayer = $EndScreenLayer

var game_scene: Node2D;

func set_main_menu_active(value: bool = true):	
	propagate_call("set_process", [value])
	propagate_call("set_physics_process", [value])
	propagate_call("set_process_input", [value])
	if value:
		show();
	else:
		hide();

func set_end_screen_active(value: bool = true):
	end_screen_layer.propagate_call("set_process", [value])
	end_screen_layer.propagate_call("set_physics_process", [value])
	end_screen_layer.propagate_call("set_process_input", [value])
	if value:
		end_screen_layer.show();
	else:
		end_screen_layer.hide();

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE;
	BgmManager.change_bgm(bgm)
	
	
	play_btn.pressed.connect(_on_play_btn_pressed)
	help_btn.pressed.connect(_on_help_button_pressed);
	quit_btn.pressed.connect(_on_exit_button_pressed);
	help_back_btn.pressed.connect(_on_help_back_button_pressed);
	
	
	EventManager.game_started.connect(_on_game_started);
	EventManager.game_ended.connect(_on_game_ended)
	EventManager.game_won.connect(_on_game_won);
	
	play_btn.grab_focus();

func _on_game_started():
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
	set_main_menu_active(false);
	EventManager.game_started.emit();
	pass
	
func _on_help_back_button_pressed():
	$MainLayer.show();
	$OptionsLayer.hide();
	pass
	
func _on_help_button_pressed():
	$MainLayer.hide();
	$OptionsLayer.show();
	pass
	
func _on_exit_button_pressed():
	get_tree().quit(1);


func _on_end_screen_btn_pressed() -> void:
	set_end_screen_active(false)
	end_screen_layer.propagate_call("hide")
	EventManager.game_ended.emit()
