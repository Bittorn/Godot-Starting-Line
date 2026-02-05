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
	return "tres"

func _get_resource_type():
	return "FlowFile"

func _get_preset_count():
	return 0

func _get_preset_name(preset_index):
	return "Unknown"

func _get_import_options(path, preset_index):
	return []

func _import(source_file, save_path, options, platform_variants, gen_files):
	var file = FileAccess.open(source_file, FileAccess.READ)
	if file == null:
		return FileAccess.get_open_error()
	
	var text: String
	var ignore := false
	
	var flow_file := FlowFile.new()
	flow_file.raw_text = file.get_as_text()
	
	while file.get_position() < file.get_length():
		var line = file.get_line().strip_edges()
		
		if line.begins_with("###"):
			ignore = !ignore
		
		if ignore:
			if line.begins_with("Title"):
				flow_file.title = line.trim_prefix("Title:").strip_edges()
			elif line.begins_with("Author"):
				flow_file.author = line.trim_prefix("Author:").strip_edges()
			elif line.begins_with("License"):
				flow_file.license = line.trim_prefix("License:").strip_edges()
			elif line.to_lower().begins_with("format version"):
				var attempt = line.to_lower().trim_prefix("format version:").strip_edges()
				if attempt.is_valid_int():
					flow_file.format_version = int(attempt)
		
		if !(line == "" or line.begins_with("#") or ignore):
			text += line + "\n"
	
	flow_file.text = text
	
	save_path = save_path + "." + 	_get_save_extension()
	return ResourceSaver.save(flow_file, save_path)
