@tool
extends Node

var file_dialog: EditorFileDialog
var current_file: FlowFile
var open_files: Array[FlowFile]

enum Mode {
	OPEN,
	SAVE,
	EXPORT_JSON,
	EXPORT_INK,
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Engine.is_editor_hint():
		file_dialog = EditorFileDialog.new()
		file_dialog.add_filter("*.flow", "Flow File")
		file_dialog.popup_file_dialog()
	else:
		queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func open_file_selector(mode: Mode) -> void:
	match mode:
		Mode.OPEN:
			file_dialog.file_selected.connect(open_file)
		Mode.SAVE:
			file_dialog.file_selected.connect(save_file)
		Mode.EXPORT_JSON:
			pass
		Mode.EXPORT_INK:
			pass

func open_file() -> void:
	pass

func save_file() -> void:
	pass
