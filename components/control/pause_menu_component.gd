class_name PauseMenuComponent extends ComponentControl

## Show when unpaused
@export var invert := false

func _ready() -> void:
	GameManager.game_paused.connect(_update.bind(false if invert else true))
	GameManager.game_unpaused.connect(_update.bind(true if invert else false))
	process_mode = Node.PROCESS_MODE_ALWAYS
	root.set_visible(invert)

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		GameManager.toggle_pause()

func _update(show: bool) -> void:
	if show:
		root.show() 
	else:
		root.hide()
