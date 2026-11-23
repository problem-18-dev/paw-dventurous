## Configuration resource for the camera of a section.
class_name CameraSectionConfigResource
extends Resource

@export_group("Follow")
## The camera's follow offset, same as [PhantomCamera3D].
@export var follow_offset := Vector3(0, 0, 2)
## Enable camera follow damping.
@export var follow_damping := false
@export_group("Look at")
## Enable looking at [Player].
@export var look_at_enabled := false
## Look at offset.
@export var look_at_offset := Vector3.ZERO
## Look at damping.
@export_range(0, 1, 0.01) var look_at_damping_value := 0.25
@export_group("Rotation")
## The camera's rotation in degrees.
@export_custom(PROPERTY_HINT_NONE, "degrees") var rotation_degrees: Vector3
