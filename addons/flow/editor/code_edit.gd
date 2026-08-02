extends CodeEdit


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_comment_delimiter("//", "")
	add_comment_delimiter("///", "///")
	set_code_region_tags("region", "endregion")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
