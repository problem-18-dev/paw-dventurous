## Handles everything camera related for the [Player].
## This interpolates the Z-axis offset manually instead of using
## the built-in [PhantomCamera3D] damping.
class_name PlayerCamera
extends Node3D

const FORWARD_Z_OFFSET := 1.3
const BACKWARD_Z_OFFSET := 2.2
const FULL_RANGE := BACKWARD_Z_OFFSET - FORWARD_Z_OFFSET

@export_group("Interpolation")
@export var forward_offset_time := 0.75
@export var backward_offset_time := 0.5
@export var trans_type := Tween.TRANS_LINEAR
@export var ease_type := Tween.EASE_OUT

var _tween: Tween
var _target_offset: float

@onready var phantom_camera: PhantomCamera3D = $PhantomCamera3D


func _ready() -> void:
	await owner.ready
	assert(owner is Player, "Camera must be child of Player.")
	phantom_camera.follow_target = owner


func _physics_process(_delta: float) -> void:
	var vertical_direction := Input.get_axis("move_backward", "move_forward")

	# Stop moving camera if not moving.
	if is_zero_approx(vertical_direction):
		_stop()
		return

	if vertical_direction > 0:
		_move_camera(FORWARD_Z_OFFSET, forward_offset_time)
	else:
		_move_camera(BACKWARD_Z_OFFSET, backward_offset_time)


## Stops any camera movement and disables processing.
func disable() -> void:
	_stop()
	set_physics_process(false)


func set_path(new_path: Path3D) -> void:
	phantom_camera.set_follow_path(new_path)


func _move_camera(target_offset: float, time: float) -> void:
	# Already moving towards target offset, so cancel any new tweening.
	if is_equal_approx(target_offset, _target_offset):
		return

	_target_offset = target_offset

	var remaining := absf(target_offset - phantom_camera.follow_offset.z) / FULL_RANGE
	if is_zero_approx(remaining):
		return

	_stop()

	_tween = create_tween().set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	_tween.set_ease(ease_type).set_trans(trans_type)
	_tween.tween_property(phantom_camera, "follow_offset:z", target_offset, time * remaining)


func _stop() -> void:
	if _tween and _tween.is_running():
		_tween.kill()
		_tween = null
	_target_offset = NAN
