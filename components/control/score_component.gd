class_name ScoreComponent extends ComponentControl


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	root.text = str(GameManager.cash)
