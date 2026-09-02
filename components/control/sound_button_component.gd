class_name SoundButtonComponent
extends ComponentControl

@export var sound: AudioStream
@export var bus: StringName
@export var test := false

func _ready():
	assert(bus, "Bus variable not set")
	if root is BaseButton:
		root.pressed.connect(play_sound)
	else:
		push_warning("Not a child of BaseButton, and may not function as intended.")
	
	if not sound:
		push_warning("Sound variable not set, will not function as intended")

func play_sound():
	if sound:
		AudioManager.play_sound(sound, bus, test)
