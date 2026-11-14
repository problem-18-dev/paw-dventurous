## To be used to buffer an input. Example is jump buffering.
@icon("input_buffer.svg")
class_name InputBuffer
extends Node

## Action name to use for input buffering.
@export_custom(PROPERTY_HINT_INPUT_NAME, "") var action_name: StringName
## How long a buffer should last per action trigger.
@export var buffer_time := 0.15

@onready var _input_buffer_timer: Timer = $InputBufferTimer


func _ready() -> void:
	_input_buffer_timer.wait_time = buffer_time


func _unhandled_input(event: InputEvent) -> void:
	if not event.is_action_pressed(action_name):
		return

	_input_buffer_timer.start()


## Returns amount of buffer time left.
func time_left() -> float:
	return _input_buffer_timer.time_left


## Returns true if input is still buffered.
func is_buffered() -> bool:
	return not _input_buffer_timer.is_stopped()


## Stops buffering (prematurely).
func settle() -> void:
	_input_buffer_timer.stop()
