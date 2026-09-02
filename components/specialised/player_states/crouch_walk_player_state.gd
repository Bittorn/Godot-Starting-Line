class_name CrouchWalkPlayerState
extends PlayerState

@export var crouch_state: PlayerState
@export var walk_state: PlayerState
@export var jump_state: PlayerState
@export var sprint_state: PlayerState

@export var crouch_walk_speed := 1.3
@export var crouch_walk_height_reduction := 0.8

func enter_state() -> void:
	if !crouch_state:
		crouch_state = try_get_state("CrouchPlayerState")
	if !walk_state:
		walk_state = try_get_state("WalkPlayerState")
	if !jump_state:
		jump_state = try_get_state("JumpPlayerState")
	if !sprint_state:
		sprint_state = try_get_state("SprintPlayerState")
	
	player.head_target.y = player.head_start_pos.y - crouch_walk_height_reduction


func exit_state() -> void:
	player.head_target.y = player.head_start_pos.y


func unhandled_input(event: InputEvent) -> void:
	_process_mouse(event)


func physics_update(delta: float) -> void:
	_process_gravity(delta)
	_process_interact()
	
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if Input.is_action_pressed("sprint") and input_dir:
		change_state(sprint_state)
	
	player.direction = (player.head.transform.basis * player.body.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if input_dir:
		if Input.is_action_pressed("crouch"):
			player.body.velocity.x = player.direction.x * crouch_walk_speed
			player.body.velocity.z = player.direction.z * crouch_walk_speed
		else:
			change_state(walk_state)
	else:
		change_state(crouch_state)
	
	player.body.move_and_slide()
