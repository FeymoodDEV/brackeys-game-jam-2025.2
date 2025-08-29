extends Node2D

@onready var ui_layer = $UILayer;

@export var packed_game_scene: PackedScene;
@export var play_btn: Button;

var game_scene: Node2D;

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE;
	play_btn.pressed.connect(_on_play_btn_pressed)
	play_btn.grab_focus();
	
	if packed_game_scene:
		game_scene = packed_game_scene.instantiate();

func _on_play_btn_pressed():
	self.hide();
	ui_layer.hide();
	EventManager.game_started.emit();
	EventManager.level_scene_instanced.emit(game_scene);
	pass
	
func _on_options_button_pressed():
	pass
	
func _on_exit_button_pressed():
	get_tree().quit(1);
