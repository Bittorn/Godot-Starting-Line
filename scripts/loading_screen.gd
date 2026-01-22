extends ProgressBar

@export var disabled: bool = false
var path: String

func _ready():
	if disabled: return
	path = GameManager.scenes[GameManager.scene_to_load]
	if ResourceLoader.has_cached(path):
		ResourceLoader.load_threaded_get(path)
	else:
		ResourceLoader.load_threaded_request(path)

func _process(_delta: float):
	var progress = []
	var status = ResourceLoader.load_threaded_get_status(path, progress)
	
	if status == ResourceLoader.ThreadLoadStatus.THREAD_LOAD_IN_PROGRESS:
		value = progress[0] * 200

	if status == ResourceLoader.ThreadLoadStatus.THREAD_LOAD_LOADED:
		value = 100
		get_tree().change_scene_to_packed(ResourceLoader.load_threaded_get(path))
			
