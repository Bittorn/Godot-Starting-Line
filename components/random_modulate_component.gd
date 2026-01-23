class_name RandomModulateComponent extends BaseComponent

@export var upper_limit := 1.0
@export var lower_limit := 0.2

func _ready() -> void:
	assert(root is CanvasItem, "Parent does not extend CanvasItem")
	root.self_modulate = Color(
		randf_range(lower_limit, upper_limit),
		randf_range(lower_limit, upper_limit),
		randf_range(lower_limit, upper_limit),
		1.0)
