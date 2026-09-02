class_name PlayerComponent
extends Component3D

## State-based movement controller
## Originally based on work by the legendary LegionGames
## https://github.com/LegionGames/FirstPersonController/blob/main/Scripts/Player.gd

@export var initial_state: PlayerState

@export_group("Settings")
@export var mouse_sensitivity: float = 4
@export var enable_view_bob := true
@export var bob_frequency := 2.0
@export var bob_amplitude := 4.0
@export var enable_fov_change := true
@export var fov_change: float = 0.8
@export var max_change_velocity: float = 40.0

@export_group("Overrides")
@export var head: Node3D
@export var camera: Camera3D
@export var collision: CollisionShape3D
@export var raycast: RayCast3D
@export var interact_label: Label

var body: CharacterBody3D
var state: PlayerState

var fov_multiplier := 1.0
var direction := Vector3.ZERO
var force_disable_view_bob := false
var head_target: Vector3
var head_start_pos: Vector3
var show_interact := false
var should_capture := true:
	set(value):
		should_capture = value
		
		if value:
			capture_mouse()
		else:
			release_mouse()

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var _base_fov: float
var _bob: float
var _starting_position: Vector3

func _ready() -> void:
	#region Sanity checks
	if !head:
		head = $"../Head"
	if !camera:
		camera = head.find_child("Camera3D")
	if !collision:
		collision = root.find_child("CollisionShape3D", false)
	if !raycast:
		raycast = camera.find_child("RayCast3D")
	if !interact_label:
		interact_label = camera.find_child("InteractLabel")
		
	assert(head != null, "Head node not found")
	assert(camera != null, "Camera3D not found as child of Head node")
	
	assert(root is CharacterBody3D, "Root node is not CharacterBody3D")
	body = root
	
	assert(collision != null, "CollisionShape3D not found as child of CharacterBody3D")
	if collision.shape is not CylinderShape3D or collision.shape is not CapsuleShape3D:
		push_warning("Collision shape has no height component, and will not be updated")
	
	if not raycast:
		push_warning("RayCast3D not found as child of Camera3D, player will not be able to interact with objects")
	else:
		if not interact_label:
			push_warning("InteractLabel not found as child of Camera3D, player will not receive prompt to interact with objects")
	#endregion
	
	if !initial_state:
		initial_state = $IdlePlayerState
	assert(initial_state != null, "Player must have an initial state")
	
	if get_tree().root.has_node("OptionsManager"):
		mouse_sensitivity = OptionsManager.get_value(OptionsManager.Option.MOUSE_SENSITIVITY)
		enable_view_bob = OptionsManager.get_value(OptionsManager.Option.VIEW_BOB)
		enable_fov_change = OptionsManager.get_value(OptionsManager.Option.FOV_ZOOM)
	
	_base_fov = camera.fov
	head_start_pos = head.position
	head_target = head_start_pos
	
	for child: PlayerState in get_children():
		child.changed_state.connect(change_state)
		child.player = self
	
	GameManager.game_paused.connect(release_mouse)
	GameManager.game_unpaused.connect(capture_mouse)
	
	change_state(initial_state)
	
	_starting_position = body.global_position
	
	capture_mouse()


func _process(delta: float) -> void:
	state.update(delta)


func _physics_process(delta: float) -> void:
	# FOV change code
	if enable_fov_change:
		var forward = head.global_basis.z
		var velocity_clamped = clamp(body.velocity.length() * fov_multiplier, 0, max_change_velocity)
		var forward_dot = body.velocity.dot(forward)
		
		velocity_clamped *= clampf(-forward_dot, -0.3, 1)
		
		var target_fov: float
		target_fov = _base_fov + fov_change * (velocity_clamped / 3)
		camera.fov = lerp(camera.fov, target_fov, delta * 10.0)
	
	# Headbob code
	_bob += delta * body.velocity.length() * float(body.is_on_floor())
	camera.transform.origin = _headbob(_bob)
	
	# Handle head position changes
	# TODO: handle head sway
	head.position = lerp(head.position, head_target, delta * 16)
	
	if collision.shape is CylinderShape3D:
		collision.shape.height = head.position.y
		collision.position.y = head.position.y / 2
	
	# Catch if the player's fallen through collision or something
	if body.position.y <= -1000:
		body.position.y += 2000
	
	if Input.is_action_just_pressed("stuck"):
		_stuck()
	
	interact_label.visible = show_interact
	show_interact = false
	state.physics_update(delta)


func _unhandled_input(event) -> void:
	state.unhandled_input(event)

func capture_mouse() -> void:
	if should_capture:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func release_mouse() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	
func change_state(new_state: PlayerState) -> void:
	if new_state == state:
		return
	
	if state:
		state.exit_state()
	state = new_state
	if state:
		state.enter_state()


func _headbob(time: float) -> Vector3:
	var pos = Vector3.ZERO
	
	if enable_view_bob and not force_disable_view_bob:
		pos.y = sin(time * bob_frequency) * (bob_amplitude / 100)
		pos.x = cos(time * bob_frequency / 2) * (bob_amplitude / 100) / 4
	
	return pos


func _stuck() -> void:
	body.global_position = _starting_position
