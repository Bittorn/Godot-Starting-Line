class_name MouseFollowComponent2D extends Component2D

@export var use_global_position := false

@export_group("Smoothing")
@export var enable_smoothing := false
@export var smoothing := 16.0

var camera_2d: Camera2D
var mouse_pos: Vector2

func _ready() -> void:
	camera_2d = get_viewport().get_camera_2d()
	if use_global_position:
		assert(camera_2d != null, "Camera2D not found and use_global_position is enabled")
	_update_mouse_pos()
	root.position = mouse_pos

func _process(delta: float) -> void:
	_update_mouse_pos()
	if enable_smoothing:
		root.position = lerp(root.position, mouse_pos, smoothing * delta)
	else:
		root.position = mouse_pos

func _update_mouse_pos() -> void:
	if use_global_position:
		mouse_pos = camera_2d.get_global_mouse_position()
	else:
		mouse_pos = get_viewport().get_mouse_position()
