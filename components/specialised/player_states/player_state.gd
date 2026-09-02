class_name PlayerState
extends State

var player: PlayerComponent

func change_state(state: State) -> void:
	if state:
		if OS.is_debug_build():
			print("New player state: ", state.name)
		changed_state.emit(state)


func unhandled_input(_event: InputEvent) -> void:
	pass


## Try to get state by it's name.[br]
## If not found, returns [code]null[/code].
func try_get_state(state_name: String) -> PlayerState:
	var state: PlayerState
	
	if player.has_node(state_name):
		state = player.get_node(state_name)
		
	return state


## Processes mouse movement based on [code]player.mouse_sensitivity[/code].[br]
## Call when you want to allow the player to move the camera.
func _process_mouse(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		player.head.rotate_y(-event.relative.x * (player.mouse_sensitivity * 0.001))
		player.camera.rotate_x(-event.relative.y * (player.mouse_sensitivity * 0.001))
		player.camera.rotation.x = clamp(player.camera.rotation.x, deg_to_rad(-60), deg_to_rad(60))


## Processes interaction states.[br]
## Call when you want to allow the player to interact with objects.
func _process_interact() -> void:
	if player.raycast.is_colliding():
		var target: Node3D = player.raycast.get_collider()
		if target != null and target.has_node("InteractComponent"):
			player.show_interact = true
			if Input.is_action_just_pressed("interact"):
				target.get_node("InteractComponent").interact(player)
		else:
			player.show_interact = false
	else:
		player.show_interact = false


## On call, decrements player's velocity by [code]player.gravity * delta[/code].[br]
## [code]player.gravity[/code] is usually taken from project settings, but may be
## overridden on the player component.
func _process_gravity(delta: float) -> void:
	if not player.body.is_on_floor():
		player.body.velocity.y -= player.gravity * delta
