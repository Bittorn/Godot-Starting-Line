extends Control

func _ready() -> void:
	GameManager.game_unpaused.connect(hide)
