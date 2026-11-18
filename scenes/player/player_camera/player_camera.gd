## Handles everything camera related for the [Player].
## This interpolates the Z-axis offset manually instead of using
## the built-in [PhantomCamera3D] damping.
class_name PlayerCamera
extends Node3D

const DEFAULT_Z_OFFSET := 1.6
const FORWARD_Z_OFFSET := 1.4
const BACKWARD_Z_OFFSET := 2.3

const OFFSET_SPEED := 1.0
const FORWARD_OFFSET_ACCEL := OFFSET_SPEED / 0.25
const BACKWARD_OFFSET_ACCEL := OFFSET_SPEED / 0.15

@export var player: Player

@onready var phantom_camera: PhantomCamera3D = $PhantomCamera3D


func _ready() -> void:
	assert(player, "No Player assigned to PlayerCamera.")


func _physics_process(delta: float) -> void:
	var vertical_direction := player.get_direction().y

	# Stop moving camera if not moving.
	if is_zero_approx(vertical_direction):
		return

	if vertical_direction < 0:
		_forward_offset(phantom_camera.follow_offset.z, delta)
	else:
		_backward_offset(phantom_camera.follow_offset.z, delta)


func _forward_offset(current_z: float, delta: float) -> void:
	if is_equal_approx(current_z, FORWARD_Z_OFFSET):
		phantom_camera.follow_offset.z = FORWARD_Z_OFFSET
		return

	phantom_camera.follow_offset.z = move_toward(
		current_z,
		FORWARD_Z_OFFSET,
		FORWARD_OFFSET_ACCEL * delta,
	)


func _backward_offset(current_z: float, delta: float) -> void:
	if is_equal_approx(current_z, BACKWARD_Z_OFFSET):
		phantom_camera.follow_offset.z = BACKWARD_Z_OFFSET
		return

	phantom_camera.follow_offset.z = move_toward(
		current_z,
		BACKWARD_Z_OFFSET,
		BACKWARD_OFFSET_ACCEL * delta,
	)
