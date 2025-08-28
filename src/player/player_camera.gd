extends Camera2D
class_name PlayerCamera

@export var look_ahead_distance: float = 100.0
@export var smoothing: float = 50.0

var target_position: Vector2

func _process(delta: float) -> void:
	if not get_parent():
		return

	var player: PlayerController = get_parent()
	var player_pos: Vector2 = player.global_position

	var viewport: Viewport = get_viewport()
	var screen_center: Vector2 = viewport.get_visible_rect().size / 2.0
	var mouse_pos: Vector2 = viewport.get_mouse_position()

	var from_center: Vector2 = mouse_pos - screen_center

	var half_size: Vector2 = screen_center
	var normalized: Vector2 = Vector2(
		from_center.x / half_size.x,
		from_center.y / half_size.y
	)

	normalized = normalized.clamp(Vector2(-1, -1), Vector2(1, 1))

	var mouse_offset: Vector2 = normalized * look_ahead_distance

	target_position = player_pos + mouse_offset

	global_position = global_position.lerp(target_position, smoothing * delta)
