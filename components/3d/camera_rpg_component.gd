class_name CameraRPGComponent extends Component3D

@export var startY = 1.0
@export var endY = 61.0

@export var startRotation = -5.0
@export var endRotation = -90.0

@export var beginY = 12.0

@export var scroll_sensitivity = 6.0

@export_group("Smoothing")
@export var enable_smoothing := true
@export var smoothing := 16.0

var targetY = beginY

func _ready() -> void:
	assert(root is Camera3D, "Parent does not inherit Camera3D")
	root.position.y = targetY
	root.rotation.x = deg_to_rad(_do_rotation())

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("zoom_in"):
		targetY = clampf(targetY - (1 * (scroll_sensitivity / 10)), startY, endY) # Might need delta here?
	if event.is_action_pressed("zoom_out"):
		targetY = clampf(targetY + (1 * (scroll_sensitivity / 10)), startY, endY)
	if event.is_action_pressed("zoom_reset"):
		targetY = beginY

func _do_rotation() -> float:
	var weight = (targetY - startY) / (endY - startY)
	var targetRotation = lerp(startRotation, endRotation, ease(weight, 0.12))
	return targetRotation

func _process(delta: float) -> void:
	var target = root.position
	target.y = targetY
	
	var targetRotation = deg_to_rad(_do_rotation())
	
	if enable_smoothing:
		root.position = lerp(root.position, target, smoothing * delta)
		root.rotation.x = lerp(root.rotation.x, targetRotation, smoothing / 1.2 * delta)
	else:
		root.position = target
		root.rotation.x = targetRotation
