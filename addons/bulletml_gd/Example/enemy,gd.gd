extends Sprite2D

@onready var spawner = $BulletSpawner

var timer = 0;
var base = 0;
var global = 0;

func _ready():
	_late_ready.call_deferred()

func _late_ready():
	spawner.Spawn("maybe", 0, 0);
	pass

func _process(delta):
	timer += delta;
	global += delta;
	if timer >= 0.1:
		spawner.SpawnFunction("cos", 0, -200);		
		spawner.SpawnFunction("sin", -310, 0)
		spawner.SpawnFunction("spiral", 0, -200);
		timer = 0;
	
