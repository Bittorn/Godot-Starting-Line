class_name UnpauseComponent
extends BaseComponent

func _init() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func _ready() -> void:
	GameManager.unpause_game()
