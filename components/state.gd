class_name State extends BaseComponent

signal changed_state(state: State)

func enter_state() -> void:
	pass


func change_state(state: State) -> void:
	if state:
		if OS.is_debug_build():
			print("New state: ", state.name)
		changed_state.emit(state)


func exit_state() -> void:
	pass


func update(_delta: float) -> void:
	pass


func physics_update(_delta: float) -> void:
	pass
