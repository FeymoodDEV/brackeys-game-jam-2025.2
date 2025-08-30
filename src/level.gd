extends Node2D;
class_name Level;


@export var level_data: LevelData;

func _ready() -> void:
	BgmManager.change_bgm(level_data.bgm)
