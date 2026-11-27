@tool
class_name RollingObstacleDoor
extends Node3D

## How long the door takes to open.
@export var open_duration := 0.4
## How long the door takes to close.
@export var close_duration := 0.6
@export_tool_button("Open door") var open_door_action: Callable = _open_door
@export_tool_button("Close door") var close_door_action: Callable = _close_door
@export_group("Open tween")
@export var open_ease_type := Tween.EaseType.EASE_OUT
@export var open_trans_type := Tween.TransitionType.TRANS_BACK
@export_group("Close tween")
@export var close_ease_type := Tween.EaseType.EASE_OUT
@export var close_trans_type := Tween.TransitionType.TRANS_BOUNCE

var _tween: Tween

@onready var door: StaticBody3D = $Door


func _open_door() -> void:
	_reset_tween()
	_tween.set_trans(open_trans_type).set_ease(open_ease_type)
	_tween.tween_property(door, "rotation:y", -PI / 2, open_duration)


func _close_door() -> void:
	_reset_tween()

	_tween.set_trans(close_trans_type).set_ease(close_ease_type)
	_tween.tween_property(door, "rotation:y", 0, close_duration)


func _reset_tween() -> void:
	if _tween:
		_tween.kill()

	_tween = create_tween().set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)


func _on_trigger_area_body_entered(_body: Node3D) -> void:
	_open_door()


func _on_trigger_area_body_exited(_body: Node3D) -> void:
	_close_door()
