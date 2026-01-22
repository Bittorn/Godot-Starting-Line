class_name OneBitButtonComponent extends ComponentControl

@export var normal_color := Color.WHITE
@export var pressed_color := Color.WHITE
@export var hovered_color := Color.WHITE
@export var disabled_color := Color.WHITE
@export var focused_color := Color.WHITE

@export var transition_speed := 24.0
@export var transition_immediately := true
@export var disable_focus := true

var target_color: Color

func _ready() -> void:
	assert(root is BaseButton, "Parent is not BaseButton")


func _process(delta: float) -> void:
	if root.disabled:
		target_color = disabled_color
	elif root.button_pressed:
		target_color = pressed_color
	elif root.is_hovered():
		target_color = hovered_color
	elif root.has_focus() and !disable_focus:
		target_color = focused_color
	else:
		target_color = normal_color
	
	if transition_immediately: root.self_modulate = target_color
	else: root.self_modulate = lerp(root.self_modulate, target_color, delta * transition_speed)
