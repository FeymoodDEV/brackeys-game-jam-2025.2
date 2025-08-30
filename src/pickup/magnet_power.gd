extends Pickup
class_name MagnetPower

@export var active_time: float = 5;
var counter = 0;

@onready var magnet_area: Area2D = $MagnetRadius;

# Check if other items enter the area
func _on_area_entered(area):
	pass # Replace with function body.

func _draw():
	if active:
		draw_circle(position, magnet_area.get_node("CollisionShape2D").shape.radius, Color.RED, false, 5);

func _process(delta):
	counter += delta;
	if counter >= active_time:
		queue_free.call_deferred();
	queue_redraw();

func _on_magnet_radius_area_entered(area):
	if active:
		if area is Pickup:
			area.global_position = global_position;
		pass # Replace with function body.
