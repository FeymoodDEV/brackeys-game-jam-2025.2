extends Pickup
class_name ShieldPower

@export var active_time: float = 5;
var counter = 0;

@onready var shield_area: Area2D = $Radius;

# Check if other items enter the area
func _on_area_entered(area):
	pass # Replace with function body.

func _draw():
	if active:
		draw_circle(position, shield_area.get_node("CollisionShape2D").shape.radius, Color.BLUE, false, 5);

func _ready():
	shield_area.set_physics_process(false);

func _process(delta):
	counter += delta;
	if counter >= active_time:
		queue_free.call_deferred();
	queue_redraw();
	
func picked_up():
	shield_area.set_physics_process(true);
