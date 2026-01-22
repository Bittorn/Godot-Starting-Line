class_name ChangeSceneComponent extends ComponentControl

@export var scene: GameManager.Scene
@export var bypass_loading := false

func _ready():
	if root is BaseButton:
		root.pressed.connect(change_scene)
	else:
		push_warning("Not a child of BaseButton, and may not function as intended.")

func change_scene():
	GameManager.load_scene(scene, bypass_loading)
