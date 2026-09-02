class_name DownscaleComponent extends ComponentControl

func _ready() -> void:
	if root is SubViewportContainer:
		root.stretch = GameManager
