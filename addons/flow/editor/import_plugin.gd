@tool
extends EditorImportPlugin

func _get_importer_name():
	return "flow.fileimport"

func _get_visible_name():
	return "Flow File"
 
func _get_priority():
	return 2

func _get_recognized_extensions():
	return ["flow"]

func _get_save_extension():
	return "flow"

func _get_resource_type():
	return "TextFile"

func _get_preset_count():
	return 0

func _can_import_threaded():
	return true # this might not be the case but who cares

func _get_preset_name(preset_index):
	return "Unknown"

func _get_import_options(path, preset_index):
	return []

func _import(source_file, save_path, options, platform_variants, gen_files):
	var file = FileAccess.open(source_file, FileAccess.READ)
	if file == null:
		return FileAccess.get_open_error()
	
	# Simply pass as standard text file for now
	var flow = file.get_as_text()
	
	return ResourceSaver.save(flow, "%s.%s" % [save_path, _get_save_extension()])
