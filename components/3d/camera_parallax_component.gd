class_name CameraParallaxComponent
extends Component3D

@export var cam_rotation_amount: float = 1.4
@export var cam_lerp_speed: float = 3

var _starting_rotation: Vector3

@onready var _viewport = get_viewport()

func _ready() -> void:
	_starting_rotation = root.rotation_degrees


func _process(delta: float) -> void:
	var mouse_x = clamp(((_viewport.get_mouse_position() / _viewport.get_visible_rect().size - Vector2(0.5, 0.5)).x * 2), -1, 1)
	var mouse_y = clamp(((_viewport.get_mouse_position() / _viewport.get_visible_rect().size - Vector2(0.5, 0.5)).y * 2), -1, 1)
	root.rotation_degrees = root.rotation_degrees.lerp(_starting_rotation + (Vector3(-mouse_y, -mouse_x, 0) * cam_rotation_amount), delta * cam_lerp_speed)
