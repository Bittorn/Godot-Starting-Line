extends Node

const AUDIO_BUS: AudioBusLayout = preload("uid://xtx7svw0qacp")

var _by_name: Dictionary[StringName, AudioStreamPlayer]

@onready var test_player := AudioStreamPlayer.new()
@onready var music_player := AudioStreamPlayer.new()
@onready var sfx_player := AudioStreamPlayer.new()
@onready var voice_player := AudioStreamPlayer.new()
@onready var ambient_player := AudioStreamPlayer.new()


@onready var piano_player := AudioStreamPlayer.new()

# remember to always add new players to the array !!
@onready var _players: Array[AudioStreamPlayer] = [test_player, music_player, sfx_player, voice_player, ambient_player, piano_player]

func _ready() -> void:
	music_player.bus = &"Music"
	sfx_player.bus = &"SFX"
	voice_player.bus = &"Voice"
	ambient_player.bus = &"Ambient"
	piano_player.bus = &"Piano"
	
	var polyphonic := AudioStreamPolyphonic.new()
	polyphonic.polyphony = 60 # WOW this is high
	piano_player.stream = polyphonic
	piano_player.autoplay = true
	
	for player in _players:
		_by_name.get_or_add(player.bus, player)
		add_child(player)


func play_sound(stream: AudioStream, bus: StringName, test := false) -> void:
	if _by_name.has(bus):
		if test:
			test_player.bus = bus
			test_player.stream = stream
			test_player.play()
		else:
			_by_name.get(bus).stream = stream
			_by_name.get(bus).play()


func play_note(note: AudioStream) -> void:
	var polyphonic: AudioStreamPlaybackPolyphonic = piano_player.get_stream_playback()
	polyphonic.play_stream(note)
