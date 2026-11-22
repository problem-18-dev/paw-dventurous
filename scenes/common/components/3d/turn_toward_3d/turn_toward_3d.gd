## Turns target towards a position in the world.
@tool
class_name TurnToward3D
extends Node3D

## Emitted when turning has snapped.
signal finished

## Target to turn. Defaults to parent.
@export var target: Node3D:
	set(value):
		target = value
		update_configuration_warnings()
@export_group("Limitation")
@export var horizontal_only := true

var _turn_position: Vector3
var _speed: float
var _snap_limit := 0.0


func _ready() -> void:
	set_physics_process(false)

	var parent := get_parent()

	if not target and parent is Node3D:
		target = parent


func _get_configuration_warnings() -> PackedStringArray:
	if not target:
		return ["No target assigned."]
	return []


func _physics_process(delta: float) -> void:
	var direction := target.global_position.direction_to(_turn_position)
	direction.y = 0.0 if horizontal_only else direction.y

	if direction.is_zero_approx():
		_finish()
		return

	var new_rotation := Basis.looking_at(direction)
	var safe_speed := clampf(_speed * delta, 0.0, 1.0)
	target.basis = target.basis.slerp(new_rotation, safe_speed)
	_attempt_snap(new_rotation, direction)


## Turns towards [param turn_position]. Interpolates at [param lerp_speed],
## optionally snaps when within [param snap_limit].[br][br]
## [b]Note:[/b] [signal finished] is emitted if [param snap_limit] provided.
func turn_toward(turn_position: Vector3, lerp_speed: float, snap_limit := 0.0) -> void:
	_turn_position = turn_position
	_speed = lerp_speed
	_snap_limit = snap_limit
	set_physics_process(true)


## Prematurely stop the turning.
func stop() -> void:
	_reset()


func _attempt_snap(new_rotation: Basis, direction: Vector3) -> void:
	if is_zero_approx(_snap_limit):
		return

	var remaining_rotation := (-target.basis.z).angle_to(direction)
	if remaining_rotation < _snap_limit:
		target.basis = new_rotation
		_finish()


func _finish() -> void:
	_reset()
	finished.emit()


func _reset() -> void:
	set_physics_process(false)
	_turn_position = Vector3.ZERO
	_speed = 0
	_snap_limit = 0
