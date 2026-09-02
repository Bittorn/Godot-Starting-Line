class_name LoadEnvironmentComponent
extends Component3D

@export var load_from_options := true

func _ready() -> void:
	assert(root is WorldEnvironment, "Root node is not WorldEnvironment")
	GameManager.environment = root
	
	if get_tree().root.has_node("OptionsManager") and load_from_options:
		OptionsManager.set_environment()
