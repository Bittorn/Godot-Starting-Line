class_name OpenWindowComponent extends ComponentControl

@export var menuNode: Control

func _ready():
	if root is BaseButton:
		root.pressed.connect(change_state)

func change_state():
	assert(menuNode != null, "Component is missing required node")
	if !menuNode.is_visible_in_tree(): 
		menuNode.show()
	else:
		menuNode.hide()
