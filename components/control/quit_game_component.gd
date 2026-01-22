class_name QuitGameComponent extends ComponentControl

func _ready():
	if OS.get_name() == "Web":
		root.disabled = true
	
	if root is BaseButton:
		root.pressed.connect(_quit)
	else:
		push_warning("Not a child of BaseButton, and may not function as intended.")

## Quits the application
func _quit():
	get_tree().quit()
