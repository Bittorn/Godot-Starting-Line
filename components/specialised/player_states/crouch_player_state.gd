class_name CrouchPlayerState
extends PlayerState

@export var idle_state: PlayerState
@export var crouch_walk_state: PlayerState
@export var jump_state: PlayerState
@export var sprint_state: PlayerState

@export var crouch_height_reduction := 0.9

func enter_state() -> void:
	if !idle_state:
		idle_state = try_get_state("IdlePlayerState")
	if !crouch_walk_state:
		crouch_walk_state = try_get_state("CrouchWalkPlayerState")
	if !jump_state:
		jump_state = try_get_state("JumpPlayerState")
	if !sprint_state:
		sprint_state = try_get_state("SprintPlayerState")
	
	player.head_target.y = player.head_start_pos.y - crouch_height_reduction


func exit_state() -> void:
	player.head_target.y = player.head_start_pos.y


func unhandled_input(event: InputEvent) -> void:
	_process_mouse(event)


func physics_update(delta: float) -> void:
	_process_gravity(delta)
	_process_interact()
	
	if Input.get_vector("move_left", "move_right", "move_up", "move_down") != Vector2.ZERO:
		change_state(crouch_walk_state)
	elif Input.is_action_pressed("crouch"):
		player.body.velocity.x = lerp(player.body.velocity.x, player.direction.x, delta * 12.0)
		player.body.velocity.z = lerp(player.body.velocity.z, player.direction.z, delta * 12.0)
	elif Input.is_action_just_pressed("jump") and player.body.is_on_floor():
		change_state(jump_state)
	else:
		change_state(idle_state)
	
	player.body.move_and_slide()
