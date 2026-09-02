extends Node

signal option_changed(key: Option, value: Variant)

## Enum of all valid option keys.
enum Option {
	FULLSCREEN,
	RESOLUTION,
	MOUSE_SENSITIVITY,
	FRAMERATE_LIMIT,
	VSYNC,
	SSR,
	SSAO,
	SDFGI,
	GLOW,
	BRIGHTNESS,
	CRT_FILTER,
	VIEW_BOB,
	FOV_ZOOM,
	DIFFICULTY,
	MAIN_VOLUME,
	MUSIC_VOLUME,
	SFX_VOLUME,
	VOICE_VOLUME,
	AMBIENT_VOLUME,
}

## Enum of all difficulty values
enum Difficulty {
	EASY = 0,
	NORMAL = 1,
	HARD = 2,
}

const CONFIG_PATH := "user://settings.cfg"
const CONFIG_SECTION := "Settings"

const _BASE_RES_Y := 720

var config = ConfigFile.new()

## Dictionary of default option values.
const _DEFAULTS: Dictionary[Option, Variant] = {
	Option.FULLSCREEN: true, # allow all fullscreen modes
	Option.RESOLUTION: 1,
	Option.MOUSE_SENSITIVITY: 6.0,
	Option.FRAMERATE_LIMIT: 60,
	Option.VSYNC: DisplayServer.VSYNC_ENABLED,
	Option.SSR: true,
	Option.SSAO: true,
	Option.SDFGI: true,
	Option.GLOW: true,
	Option.BRIGHTNESS: 1.0,
	Option.CRT_FILTER: true,
	Option.VIEW_BOB: true,
	Option.FOV_ZOOM: true,
	Option.DIFFICULTY: Difficulty.NORMAL,
	Option.MAIN_VOLUME: 1.0,
	Option.MUSIC_VOLUME: 1.0,
	Option.SFX_VOLUME: 1.0,
	Option.VOICE_VOLUME: 1.0,
	Option.AMBIENT_VOLUME: 1.0,
}

## Dictionary of dev option overrides.
const _DEV_OVERRIDES: Dictionary[Option, Variant] = {
	#Option.FULLSCREEN: false,
	Option.MOUSE_SENSITIVITY: 8.0,
	Option.FRAMERATE_LIMIT: 120,
	Option.MAIN_VOLUME: 0.6,
	Option.CRT_FILTER: true,
}

func _ready():
	var err: Error = config.load(CONFIG_PATH)

	if err != OK:
		push_warning("Options file didn't load: ", error_string(err))
		reset_values()
	elif OS.get_cmdline_args().find("--reset-save") != -1:
		print("--reset-save flag set, resetting save...")
		reset_values()
	
	get_window().min_size = Vector2i(640, 360)
	
	update_video_settings()
	update_audio_settings()


## Sets the WorldEnviroment node of GameManager to saved values
func set_environment() -> void:
	if not GameManager.environment:
		push_warning("Trying to set environment values, but Environment is null")
		return
	
	GameManager.environment.environment.ssr_enabled = get_value(Option.SSR)
	GameManager.environment.environment.ssao_enabled = get_value(Option.SSAO)
	GameManager.environment.environment.sdfgi_enabled = get_value(Option.SDFGI)
	GameManager.environment.environment.glow_enabled = get_value(Option.GLOW)
	
	var brightness: float = get_value(Option.BRIGHTNESS)
	
	if get_value(Option.CRT_FILTER):
		brightness += 0.1
	
	GameManager.environment.environment.adjustment_brightness = brightness


## Sets all options to their pre-defined defaults
func reset_values() -> void:
	for key in _DEFAULTS:
		set_value(key, _DEFAULTS[key])


## Writes a new value to the settings file
func set_value(key: Option, value: Variant) -> void:
	config.set_value(CONFIG_SECTION, Option.keys()[key], value)

	var err: Error = config.save(CONFIG_PATH)
	
	if err != OK:
		push_error("Options file didn't save: ", error_string(err))
	
	option_changed.emit(key, value)


## Gets the value in the settings file.[br]
## If no value is found, resets to default and returns.
func get_value(key: Option) -> Variant:
	if OS.has_feature("editor") and _DEV_OVERRIDES.has(key):
		print("Dev override for key: ", Option.keys()[key])
		return _DEV_OVERRIDES[key]
	
	print("Getting value: ", Option.keys()[key])
	if not config.has_section_key(CONFIG_SECTION, Option.keys()[key]):
		print("Settings file does not have key %s, returning default" % Option.keys()[key])
		set_value(key, _DEFAULTS[key])
	
	return config.get_value(CONFIG_SECTION, Option.keys()[key])


## Sets fullscreen.
func set_fullscreen(fullscreen: bool = true) -> void:
	if fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		get_window().size = get_value(Option.RESOLUTION)
		get_window().move_to_center() # doesn't do anything in editor
	set_value(Option.FULLSCREEN, fullscreen) # is this necessary?


## Updates the game window to reflect current settings.
func update_video_settings() -> void:
	set_fullscreen(get_value(Option.FULLSCREEN))
	
	DisplayServer.window_set_vsync_mode(get_value(Option.VSYNC))
	Engine.max_fps = get_value(Option.FRAMERATE_LIMIT)
	get_window().scaling_3d_scale = get_value(Option.RESOLUTION)


## Updates the game audio to reflect current settings.
func update_audio_settings() -> void:
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Master"), get_value(Option.MAIN_VOLUME))
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Music"), get_value(Option.MUSIC_VOLUME))
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("SFX"), get_value(Option.SFX_VOLUME))
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Voice"), get_value(Option.VOICE_VOLUME))
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Ambient"), get_value(Option.AMBIENT_VOLUME))


## Updates all settings.[br]
## Calls [code]update_video_settings[/code] and [code]update_audio_settings[/code]
func update_settings() -> void:
	update_video_settings()
	update_audio_settings()


## Alias for [code]set_fullscreen(false)[/code]
func set_windowed() -> void:
	set_fullscreen(false)


## Toggles fullscreen mode
func toggle_fullscreen() -> void:
	set_fullscreen(!get_value(Option.FULLSCREEN))
