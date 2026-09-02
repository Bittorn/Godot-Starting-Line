class_name RotateSkyComponent extends Component3D

@export var rotation_speed := 1.0

func _ready() -> void:
	assert(root is WorldEnvironment, "Root node is not WorldEnvironment")


func _process(delta: float) -> void:
	root.environment.sky_rotation.y += rotation_speed/100 * delta
