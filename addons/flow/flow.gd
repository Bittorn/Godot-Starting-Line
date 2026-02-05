@tool
extends EditorPlugin

const MAIN_PANEL: PackedScene = preload("uid://431hatrlfpat")
const IMPORT_PLUGIN := preload("uid://bqlkc2qbmu7rg")
const PLUGIN_NAME := "Flow"
const PLUGIN_ICON_PATH := "uid://680dnxjqvduc"

var dock: Control
var import_plugin

#region Plugin Setup

func _enable_plugin() -> void:
	pass

func _disable_plugin() -> void:
	#remove_autoload_singleton(PLUGIN_NAME)
	pass

func _enter_tree() -> void:
	import_plugin = IMPORT_PLUGIN.new()
	add_import_plugin(import_plugin)
	#add_autoload_singleton(PLUGIN_NAME, "res://addons/flow/editor/autoload.tscn")
	#dock = MAIN_PANEL.instantiate()
	
	## Add to top bar with Script and AssetLib and such
	#EditorInterface.get_editor_main_screen().add_child(dock)
	
	_make_visible(false)

func _exit_tree() -> void:
	remove_import_plugin(import_plugin)
	import_plugin = null
	
	if dock:
		dock.queue_free()

#endregion

#region Plugin Info

func _has_main_screen() -> bool:
	#return true
	return false

func _get_plugin_name() -> String:
	return PLUGIN_NAME

func _get_plugin_path() -> String:
	return get_script().resource_path.get_base_dir()

func _get_plugin_icon() -> Texture2D:
	return load(PLUGIN_ICON_PATH)

#endregion

#region Editor Interaction

func _make_visible(visible: bool) -> void:
	if !dock: return

	if dock.get_parent() is Window and visible:
		EditorInterface.set_main_screen_editor("Script")
		dock.show()
		dock.get_parent().grab_focus()
	else:
		dock.visible = visible

#endregion
