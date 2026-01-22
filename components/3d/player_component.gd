class_name PlayerComponent extends Component3D

# Script based on work by the legendary LegionGames
# https://github.com/LegionGames/FirstPersonController/blob/main/Scripts/Player.gd

var speed: float
const WALK_SPEED = 4.0
const SPRINT_SPEED = 9.0
const JUMP_VELOCITY = 5.0
const CROUCH_SPEED = 1.2
const SLIDE_DECAY_SPEED = 4.0
@export var mouse_sensitivity: float = 4

const BOB_FREQ = 2.0
const BOB_AMP = 0.04
var t_bob: float

var sprinting: bool
var crouching: bool

@export var enable_view_bob := true
@export var enable_fov_change := true
@export var enable_sprint := true
@export var enable_crouch := true

var base_fov: float
@export var fov_change = 0.5

var head_y: float

## Get the gravity from the project settings.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var head: Node3D
var camera: Camera3D

func _ready():
	head = $"../Head"
	camera = $"../Head/Camera3D"
	base_fov = camera.fov
	head_y = head.position.y
	assert(head != null, "Head node not found")
	assert(camera != null, "Camera3D not found as child of Head")
	assert(root is CharacterBody3D, "Root node is not CharacterBody3D")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * (mouse_sensitivity * 0.001))
		camera.rotate_x(-event.relative.y * (mouse_sensitivity * 0.001))
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-60), deg_to_rad(60))


func _physics_process(delta):
	# Add gravity
	if not root.is_on_floor():
		root.velocity.y -= gravity * delta

	# Handle jump
	if Input.is_action_just_pressed("jump") and root.is_on_floor():
		root.velocity.y = JUMP_VELOCITY
		if crouching:
			root.velocity.y += (JUMP_VELOCITY * 0.5)
	
	# Handle sprint/crouch
	if enable_sprint: sprinting = Input.is_action_pressed("sprint")
	if enable_crouch: crouching = Input.is_action_pressed("crouch")
	
	var t_pos_y := head_y
	
	if crouching:
		if root.is_on_floor():
			t_pos_y = head_y - 0.85
		if root.velocity.length() > WALK_SPEED * 1.05:
			speed = lerp(speed, WALK_SPEED, delta * SLIDE_DECAY_SPEED)
		else:
			speed = CROUCH_SPEED
	elif sprinting:
		speed = SPRINT_SPEED
	else:
		speed = WALK_SPEED
	
	head.position.y = lerp(head.position.y, t_pos_y, delta * 16)

	# Get input direction and handle movement/deceleration
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction = (head.transform.basis * root.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if root.is_on_floor():
		if direction:
			root.velocity.x = direction.x * speed
			root.velocity.z = direction.z * speed
		else:
			root.velocity.x = lerp(root.velocity.x, direction.x * speed, delta * 12.0)
			root.velocity.z = lerp(root.velocity.z, direction.z * speed, delta * 12.0)
	else:
		root.velocity.x = lerp(root.velocity.x, direction.x * speed, delta * 5.0)
		root.velocity.z = lerp(root.velocity.z, direction.z * speed, delta * 5.0)
	
	# Head bob
	t_bob += delta * root.velocity.length() * float(root.is_on_floor())
	camera.transform.origin = _headbob(t_bob)
	
	# FOV
	if enable_fov_change:
		# TODO: only change FOV if moving forward
		var velocity_clamped = clamp(root.velocity.length(), 0.5, SPRINT_SPEED * 2)
		var target_fov: float
		if sprinting:
			target_fov = base_fov + fov_change * (velocity_clamped * 2)
		else:
			target_fov = base_fov + fov_change * (velocity_clamped / 3)
		camera.fov = lerp(camera.fov, target_fov, delta * 10.0)
	
	root.move_and_slide()


func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	if enable_view_bob and !crouching:
		pos.y = sin(time * BOB_FREQ) * BOB_AMP
		pos.x = cos(time * BOB_FREQ / 2) * BOB_AMP / 4
	return pos
