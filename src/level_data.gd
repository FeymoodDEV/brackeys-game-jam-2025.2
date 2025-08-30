extends Resource
class_name LevelData;

@export var map_time: float = 10;

## map width and height references cell count
@export var map_width: int = 40
@export var map_height: int = 30

## so blocks are being placed in clusters rather scattered around
@export var cluster_chance: float = 0.01
@export var cluster_size: int = 4

@export var border_scene: PackedScene

@export var block_scenes: Array[PackedScene]
@export var enemy_scene: PackedScene = preload("res://prefabs/enemies/basic_enemy.tscn")
@export var enemy_datas: Array[EnemyData]
@export var background_tiles: Array[Texture]

@export var boss_scene: PackedScene
