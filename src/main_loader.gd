extends Node2D

@export var packed_bullet_manager: PackedScene;
@export var packed_logo_scene: PackedScene;
@export var packed_menu_scene: PackedScene;
@export var packed_ui_scene: PackedScene;

@export_category("Debug Variables")
@export var debug_mode: bool;
@export var packed_test_scene: PackedScene;


var bullet_manager: Node2D #TODO Create class type for this
var menu_scene: Node2D;
var logo_scene: Node2D;
var testing_scene_node: Node2D;

func _on_game_scene_loaded():
	if is_instance_valid(bullet_manager):
		add_child(bullet_manager);
		Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN;

func _init():
	pass
	
func _ready():
	EventManager.game_scene_loaded.connect(_on_game_scene_loaded);
	
	if debug_mode:
		testing_scene_node = packed_test_scene.instantiate();
	
	if packed_bullet_manager:
		bullet_manager = packed_bullet_manager.instantiate();
	
	if packed_menu_scene:
		menu_scene = packed_menu_scene.instantiate();
	else:
		push_warning("Menu PackedScene null!")
		
	if packed_logo_scene:
		logo_scene = packed_logo_scene.instantiate();
	else:
		push_warning("Logo PackedScene null!")		
	
	if is_instance_valid(logo_scene):
		add_child(logo_scene);
			
	if is_instance_valid(menu_scene):
		add_child(menu_scene);
	
