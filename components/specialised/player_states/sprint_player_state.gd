class_name SprintPlayerState
extends PlayerState

@export var idle_state: PlayerState
@export var jump_state: PlayerState
@export var walk_state: PlayerState
@export var slide_state: PlayerState

@export var run_speed = 9.0
@export var fov_multiplier = 4.0

func enter_state() -> void:
	if !idle_state:
		idle_state = try_get_state("IdlePlayerState")
	if !jump_state:
		jump_state = try_get_state("JumpPlayerState")
	if !walk_state:
		walk_state = try_get_state("WalkPlayerState")
	if !slide_state:
		slide_state = try_get_state("SlidePlayerState")
		if !slide_state:
			push_warning("Could not find SlidePlayerState, falling back to CrouchWalkPlayerState")
			slide_state = try_get_state("CrouchWalkPlayerState")
	
	player.fov_multiplier = fov_multiplier


func exit_state() -> void:
	player.fov_multiplier = 1


func unhandled_input(event: InputEvent) -> void:
	_process_mouse(event)


func physics_update(delta: float) -> void:
	_process_gravity(delta)
	_process_interact()
	
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	player.direction = (player.head.transform.basis * player.body.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if Input.is_action_pressed("sprint") and input_dir.y < 0:
		player.body.velocity.x = player.direction.x * run_speed
		player.body.velocity.z = player.direction.z * run_speed
	elif input_dir:
		change_state(walk_state)
	else:
		change_state(idle_state)
	
	player.body.move_and_slide()
