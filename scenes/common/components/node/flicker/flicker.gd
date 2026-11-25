## Enables easy flickering of a Node
@tool
class_name Flicker
extends Node

## Emitted when flicker has finished.
signal finished

var _tween: Tween

## Target node to flicker.
@export var flicker_target: Node:
	set(value):
		flicker_target = value
		update_configuration_warnings()
## Interval between flickers.
@export_range(0.01, 1.0) var flicker_interval := 0.05


func _get_configuration_warnings() -> PackedStringArray:
	if not flicker_target or flicker_target is not Node:
		return ["Flicker target must be a Node."]
	return []


## Enables flicker.
func enable() -> void:
	_kill_tween()
	flicker_target.hide()
	_tween = create_tween().set_loops()
	_tween.tween_callback(flicker_target.show).set_delay(flicker_interval)
	_tween.tween_callback(flicker_target.hide).set_delay(flicker_interval)


func disable() -> void:
	_kill_tween()
	flicker_target.show()
	finished.emit()


func _kill_tween() -> void:
	if _tween:
		_tween.kill()
