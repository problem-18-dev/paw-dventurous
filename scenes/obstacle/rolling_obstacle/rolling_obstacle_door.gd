class_name RollingObstacleDoor
extends Node3D

## How long the door takes to close.
@export var close_duration := 0.5
## How long the door takes to open.
@export var open_duration := 0.5
@export_group("Tween")
@export var ease_type := Tween.EaseType.EASE_IN
@export var trans_type := Tween.TransitionType.TRANS_BACK

var _tween: Tween

@onready var door: StaticBody3D = $Door


func _open_door() -> void:
	_reset_tween()
	_tween.set_ease(Tween.EASE_OUT)
	_tween.tween_property(door, "rotation:y", -PI / 2, open_duration)


func _close_door() -> void:
	_reset_tween()

	_tween.set_ease(Tween.EASE_OUT)
	_tween.tween_property(door, "rotation:y", 0, close_duration)


func _reset_tween() -> void:
	if _tween:
		_tween.kill()

	_tween = create_tween().set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	_tween.set_trans(trans_type).set_ease(ease_type)


func _on_trigger_area_body_entered(_body: Node3D) -> void:
	_open_door()


func _on_trigger_area_body_exited(_body: Node3D) -> void:
	_close_door()
