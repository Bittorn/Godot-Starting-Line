@icon("res://addons/flow/icon.svg")
class_name FlowFile extends Resource

const LATEST_FORMAT_VERSION = 1

var text: String
var raw_text: String

@export var title: String
@export var author: String
@export var license: String
@export_range(1, LATEST_FORMAT_VERSION) var format_version: int

# make sure that every parameter has a default value
# or there will be problems with creating and editing
# the resource via the inspector
func _init(
		p_text = "",
		p_raw_text = "",
		p_title = "",
		p_author = "",
		p_license = "",
		p_format_version = LATEST_FORMAT_VERSION):
	text = p_text
	raw_text = p_raw_text
	
	title = p_title
	author = p_author
	license = p_license
	format_version = p_format_version
