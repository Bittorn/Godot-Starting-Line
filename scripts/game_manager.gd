extends Node

## Enum of all valid scenes
enum Scene {
	MAIN_MENU,
}

var scene_to_load: Scene

@onready var loading_scene = preload("res://scenes/loading.tscn")

## Dictionary of all valid scene values
var scenes: Dictionary[Scene, String] = {
	Scene.MAIN_MENU: "res://scenes/main_menu.tscn",
}

func load_scene(identifier: Scene, bypass: bool = false):
	if bypass:
		get_tree().change_scene_to_file(scenes[identifier])
	else:
		scene_to_load = identifier
		get_tree().change_scene_to_packed(loading_scene)
