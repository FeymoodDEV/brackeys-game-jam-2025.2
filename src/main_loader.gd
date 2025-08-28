extends Node2D

@export var packed_bullet_manager: PackedScene;
@export var packed_menu_scene: PackedScene;
@export var packed_ui_scene: PackedScene;
@export var packed_player_scene: PackedScene;

@export_category("Debug Variables")
@export var DebugMode: bool;
@export var packed_test_scene: PackedScene;


var bullet_manager: Node2D #TODO Create class type for this
var menu_scene: Node2D;
var testing_scene_node: Node2D;
var player_node: Node2D;

func _init():
	pass
	
func _ready():
	testing_scene_node = packed_test_scene.instantiate();
	
	if packed_bullet_manager:
		bullet_manager = packed_bullet_manager.instantiate();
	
	if packed_menu_scene:
		menu_scene = packed_menu_scene.instantiate();
		
	if packed_player_scene:
		player_node = packed_player_scene.instantiate();
	
	
	if is_instance_valid(bullet_manager):
		add_child(bullet_manager);
	else:
		push_warning("BulletManager node invalid")
		
	if is_instance_valid(menu_scene):
		add_child(menu_scene);
	else:
		push_warning("MenuScene node invalid!")
		
	if is_instance_valid(player_node):
		add_child(player_node);
	else:
		push_warning("PlayerNode invalid")
	
	if DebugMode:
		add_child(testing_scene_node);

# Handles setting up the bullet manager and pooling all bullet types
func _bullet_manager_init():
	bullet_manager = packed_bullet_manager.instantiate();
	
