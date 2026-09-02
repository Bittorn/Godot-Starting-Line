class_name OptionHideComponent
extends ComponentControl

@export var option: OptionsManager.Option
@export var invert := false

func _ready() -> void:
	OptionsManager.option_changed.connect(changed)
	root.visible = not OptionsManager.get_value(option) == not invert

func changed(key: OptionsManager.Option, value: Variant):
	if key == option:
		root.visible = not value == not invert
