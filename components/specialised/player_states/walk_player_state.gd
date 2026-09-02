class_name WalkPlayerState
extends PlayerState

@export var idle_state: PlayerState
@export var jump_state: PlayerState
@export var sprint_state: PlayerState
@export var crouch_walk_state: PlayerState

@export var walk_speed = 4.0

func enter_state() -> void:
	if !idle_state:
		idle_state = try_get_state("IdlePlayerState")
	if !jump_state:
		jump_state = try_get_state("JumpPlayerState")
	if !sprint_state:
		sprint_state = try_get_state("SprintPlayerState")
	if !crouch_walk_state:
		crouch_walk_state = try_get_state("CrouchWalkPlayerState")


func unhandled_input(event: InputEvent) -> void:
	_process_mouse(event)


func physics_update(delta: float) -> void:
	_process_gravity(delta)
	_process_interact()
	
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if Input.is_action_pressed("sprint") and input_dir.y < 0:
		change_state(sprint_state)
	
	player.direction = (player.head.transform.basis * player.body.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if input_dir:
		if Input.is_action_pressed("crouch"):
			change_state(crouch_walk_state)
		player.body.velocity.x = player.direction.x * walk_speed
		player.body.velocity.z = player.direction.z * walk_speed
	else:
		change_state(idle_state)
	
	player.body.move_and_slide()
