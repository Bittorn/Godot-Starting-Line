class_name InteractComponent
extends BaseComponent

@export var target: Node
@export var method := &"interact"

func _ready():
	if !target:
		push_warning("InteractComponent has no target node set")
	elif not target.has_method(method):
		push_warning("InteractComponent target node is missing required method \"%s\"" % method)

func interact(player: PlayerComponent):
	if target:
		if target.has_method(method):
			target.call(method, player)
		else:
			push_warning("InteractComponent interacted with, but target node is missing required method \"%s\"" % method)
	else:
		push_warning("InteractComponent interacted with, but is missing target")
