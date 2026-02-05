class_name FlowRunner extends Node

#region Signals

## Emitted when the runtime encounters an exception.
signal exception_raised(message)

## Emitted with `true` when the runtime has loaded the file and created
## the Flow. If an error was encountered, `success` will be `false` and
## and error will appear in Godot's output.
signal loaded(success)

## Emitted with the text and tags of the current line when the Flow
## is successfully continued.
signal continued(text, tags)

## Emitted when the player should pick a choice.
signal prompt_choices(choices)

## Emitted when a choice was made.
signal choice_made(choice)

## Emitted when an external function is about to evaluate.
signal function_evaluating(function_name, arguments)

## Emitted when an external function has finished evaluating.
signal function_evaluated(function_name, arguments, function_result)

## Emitted when a valid path string has been chosen.
signal path_chosen(path, arguments)

## Emitted when the Flow has ended.
signal ended()

#endregion

#region Properties

## The raw Flow file to load.
@export var flow_file: Resource

## `true` to allow external functions, `false` otherwise. If this
## property is `true` and the appropriate function hasn't been bound, the
## Flow will throw an error.
var allow_external_functions := true

var _loaded := false
var _external_functions: Dictionary[String, Callable]

#endregion

#region Initialisation

func _init():
	name = "FlowRunner"

#endregion

#region Overrides

#func _exit_tree():
	#call_deferred("_remove_runtime")

#endregion

#region Methods

## Binds an external function.
func bind_function(function_name: String, function: Callable):
	assert(!_external_functions.has(function_name), "Function '%s' has already been bound." % function_name)
	_external_functions[function_name] = function

## Unbinds an external function.
func unbind_function(function_name: String):
	assert(_external_functions.has(function_name), "Function '%s' does not exist." % function_name)
	_external_functions.erase(function_name)

## Returns if function exists and is bound
func has_function(function_name: String) -> bool:
	return _external_functions.has(function_name)

## Evaluate a given function, returning its return value
func evaluate_function(function_name: String, arguments = []) -> Variant:
	if !allow_external_functions: return
	if has_function(function_name):
		return _external_functions[function_name].callv(arguments)
	else:
		push_warning("Function %s does not exist or has not been bound." % function_name)
		return null

#endregion
