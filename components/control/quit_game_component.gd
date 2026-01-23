class_name QuitGameComponent extends ComponentControl

@export var allow_on_web := false

func _ready():
	if OS.get_name() == "Web" and !allow_on_web:
		root.disabled = true
	
	if root is BaseButton:
		root.pressed.connect(_quit)
	else:
		push_warning("Not a child of BaseButton, and may not function as intended.")

func _quit():
	get_tree().quit()
