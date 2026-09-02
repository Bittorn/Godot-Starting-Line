class_name OptionComponent
extends ComponentControl

@export var option: OptionsManager.Option

func _ready() -> void:
	assert(root is Button, "Root node is not/does not inherit from Button")
	
	var value = OptionsManager.get_value(option)
	
	if value is bool:
		if root is CheckBox or root is CheckButton:
			pass
		else:
			pass
	elif value is int or value is float:
		if root is OptionButton or root is Slider:
			pass
		else:
			pass
