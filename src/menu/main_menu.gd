extends Node2D

@export var packed_game_scene: PackedScene;

@export var play_btn: Button;
@export var help_btn: Button;
@export var quit_btn: Button;

@export var help_back_btn: Button;

@onready var main_layer: CanvasLayer = $MainLayer;
@onready var options_layer: CanvasLayer = $OptionsLayer;

var game_scene: Node2D;

func set_active(value: bool = true):
	propagate_call("set_process", [value])
	propagate_call("set_physics_process", [value])
	propagate_call("set_process_input", [value])
	if value:
		show();
	else:
		hide();

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE;
	
	play_btn.pressed.connect(_on_play_btn_pressed)
	help_btn.pressed.connect(_on_help_button_pressed);
	quit_btn.pressed.connect(_on_exit_button_pressed);
	help_back_btn.pressed.connect(_on_help_back_button_pressed);
	
	
	EventManager.game_started.connect(_on_game_started);
	EventManager.game_ended.connect(_on_game_ended);
	
	play_btn.grab_focus();
	
func _on_game_started():
	set_active(false);
	main_layer.propagate_call("hide");
	
func _on_game_ended():
	set_active(true);
	main_layer.propagate_call("show")

func _on_play_btn_pressed():
	set_active(false);
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
