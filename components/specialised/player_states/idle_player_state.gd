class_name IdlePlayerState
extends PlayerState

@export var walk_state: PlayerState
@export var jump_state: PlayerState
@export var crouch_state: PlayerState

func enter_state() -> void:
	if !walk_state:
		walk_state = try_get_state("WalkPlayerState")
	if !jump_state:
		jump_state = try_get_state("JumpPlayerState")
	if !crouch_state:
		crouch_state = try_get_state("CrouchPlayerState")


func unhandled_input(event: InputEvent) -> void:
	_process_mouse(event)


func physics_update(delta: float) -> void:
	_process_gravity(delta)
	_process_interact()
	
	if Input.get_vector("move_left", "move_right", "move_up", "move_down") != Vector2.ZERO:
		change_state(walk_state)
	else:
		player.body.velocity.x = lerp(player.body.velocity.x, player.direction.x, delta * 12.0)
		player.body.velocity.z = lerp(player.body.velocity.z, player.direction.z, delta * 12.0)
	
	if Input.is_action_pressed("crouch"):
		change_state(crouch_state)
	
	if Input.is_action_pressed("jump") and player.body.is_on_floor():
		change_state(jump_state)
	
	player.body.move_and_slide()
