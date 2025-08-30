extends Pickup
class_name MagnetPower

@export var active_time: float = 5;
var counter = 0;

@onready var shield_area: Area2D = $Radius;

# Check if other items enter the area
func _on_area_entered(area):
	pass # Replace with function body.

func _ready():
	Spawning.bullet_collided_area.connect(_absorb_bullet);

func _absorb_bullet(area:Area2D,area_shape_index:int, bullet:Dictionary,local_shape_index:int,shared_area:Area2D) -> void:
	var rid = Spawning.shape_rids.get(shared_area.name, {}).get(local_shape_index)
	var points = bullet["props"]["absorb_points"]
	if player:
		player._absorb_bullet(rid, points);

func _draw():
	if active:
		draw_circle(position, shield_area.get_node("CollisionShape2D").shape.radius, Color.RED, false, 5);

func _process(delta):
	counter += delta;
	if counter >= active_time:
		queue_free.call_deferred();
	queue_redraw();
	
func picked_up():
	shield_area.set_physics_process(true);
