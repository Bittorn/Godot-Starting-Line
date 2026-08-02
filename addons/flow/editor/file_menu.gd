@tool
extends PopupMenu

@onready var main_panel: Control = $"../../../../.."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_id_pressed(id: int) -> void:
	match id:
		0: # New Flow...
			OS.alert("Feature not yet implemented", "Not yet implemented")
		1: # Open...
			OS.alert("Feature not yet implemented", "Not yet implemented")
		3: # Save
			OS.alert("Feature not yet implemented", "Not yet implemented")
		4: # Save as...
			OS.alert("Feature not yet implemented", "Not yet implemented")
		5: # Save All
			OS.alert("Feature not yet implemented", "Not yet implemented")
		7: # Export as JSON...
			OS.alert("Feature not yet implemented", "Not yet implemented")
		8: # Export as Ink...
			OS.alert("Feature not yet implemented", "Not yet implemented")

func _on_open_pressed() -> void:
	FileDialog
