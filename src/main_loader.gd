extends Node2D

@export var packed_logo_scene: PackedScene;
@export var packed_menu_scene: PackedScene;
@export var packed_ui_scene: PackedScene;

@export_category("Debug Variables")
@export var debug_mode: bool;
@export var packed_test_scene: PackedScene;

@export var preload_scenes: Array[PackedScene]

var bullet_manager: Node2D #TODO Create class type for this
var menu_scene: Node2D;
var logo_scene: Node2D;
var testing_scene_node: Node2D;

func _init():
	pass

func _on_game_ended():
	$PlayerUI.hide();
	menu_scene.show()
	
func _on_game_started():
	$PlayerUI.show();
	menu_scene.hide()
	
func _deferred_ready():
	Spawning.spawn(self, "player_level_1", "0")
	Spawning.spawn(self, "chocolate_spin_pattern", "1")
	Spawning.spawn(self, "chocolate_v_shape_pattern", "1")
	Spawning.spawn(self, "enemy_circle_sugar", "1")
	Spawning.spawn(self, "enemy_circle", "1")
	Spawning.spawn(self, "enemy_one", "1")
	
func _ready():	
	$PlayerUI.hide();
	EventManager.game_started.connect(_on_game_started);
	EventManager.game_ended.connect(_on_game_ended);
	
	if debug_mode:
		testing_scene_node = packed_test_scene.instantiate();
	
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
	
	if preload_scenes.size() > 0:
		for packed in preload_scenes:
			var p_node = packed.instantiate();
			if p_node is GPUParticles2D:
				p_node.emitting = true
			elif p_node is VFXSprite2D:
				p_node.play(&"default")
			$Preloaded.add_child(p_node);
	_deferred_ready.call_deferred();
		
