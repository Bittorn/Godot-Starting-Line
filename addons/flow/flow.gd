@tool
extends EditorPlugin

const MAIN_PANEL: PackedScene = preload("uid://431hatrlfpat")
const PLUGIN_NAME := "Flow"
const PLUGIN_ICON_PATH := ""

var editor_view: Control

#region Plugin Setup

func _enable_plugin() -> void:
	# Add autoloads here.
	pass


func _disable_plugin() -> void:
	# Remove autoloads here.
	pass


func _enter_tree() -> void:
	# Initialization of the plugin goes here.
	pass


func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	pass

#endregion

#region Plugin Info

func _has_main_screen() -> bool:
	return true

func _get_plugin_name() -> String:
	return PLUGIN_NAME

func _get_plugin_path() -> String:
	return get_script().resource_path.get_base_dir()

func _get_plugin_icon() -> Texture2D:
	return load(PLUGIN_ICON_PATH)

#endregion
