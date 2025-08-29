extends Node2D

@onready var ui_layer = $UILayer;

@export var packed_game_scene: PackedScene;
@export var play_btn: Button;

var game_scene: Node2D;

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE;
	play_btn.pressed.connect(_on_play_btn_pressed)
	
	EventManager.game_started.connect(_on_game_started);
	EventManager.game_ended.connect(_on_game_ended);
	
	play_btn.grab_focus();
	
func _on_game_started():
	ui_layer.hide();
	set_process(false);
	set_process_input(false);
	
func _on_game_ended():
	set_process(true);
	set_process_input(true);
	ui_layer.show();

func _on_play_btn_pressed():
	EventManager.game_started.emit();
	pass
	
func _on_options_button_pressed():
	pass
	
func _on_exit_button_pressed():
	get_tree().quit(1);
