class_name PauseGameComponent extends ComponentControl

func _ready():
	if root is BaseButton:
		root.pressed.connect(_toggle_pause)
	else:
		push_warning("Not a child of BaseButton, and may not function as intended.")

func _toggle_pause():
	GameManager.toggle_pause()
