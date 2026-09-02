class_name RotateComponent
extends Component3D

@export var rotate_speed := 1.0

func _physics_process(delta: float) -> void:
	root.rotate_y(rotate_speed / 100 * delta)
