@tool
class_name CameraSection
extends Node3D

const COLLISION_LAYER_PLAYER := 1
const PRIORITY_ACTIVE := 2
const PRIORITY_INACTIVE := 1
const PRIORITY_READY := 0

@export var config_resource: CameraSectionConfigResource:
	set(value):
		config_resource = value
		update_configuration_warnings()

var _area: Area3D
var _path: Path3D
var _camera: PhantomCamera3D


func _ready() -> void:
	if Engine.is_editor_hint() or not config_resource:
		return

	_area = $Area3D
	_path = $Path3D
	_camera = $PhantomCamera3D

	_setup_camera()
	_setup_area()


func _get_configuration_warnings() -> PackedStringArray:
	var errors: PackedStringArray = []

	if find_children("*", "Area3D").is_empty():
		errors.append("Camera section must have an Area3D.")

	if find_children("*", "Path3D").is_empty():
		errors.append("Camera section must have a Path3D.")

	if find_children("*", "PhantomCamera3D").is_empty():
		errors.append("Camera section must have a PhantomCamera3D.")

	if not config_resource:
		errors.append("No config resource set.")

	return errors


func _setup_camera() -> void:
	_camera.tween_on_load = false
	_camera.priority = PRIORITY_READY
	_camera.follow_path = _path

	# Follow
	_camera.follow_mode = PhantomCamera3D.FollowMode.PATH
	_camera.follow_offset = config_resource.follow_offset
	_camera.follow_damping = config_resource.follow_damping

	# Look at
	_camera.look_at_damping = config_resource.look_at_enabled
	_camera.look_at_mode = PhantomCamera3D.LookAtMode.SIMPLE
	_camera.look_at_offset = config_resource.look_at_offset
	_camera.look_at_damping_value = config_resource.look_at_damping_value

	# Rotation
	_camera.rotation_degrees = config_resource.rotation_degrees


func _setup_area() -> void:
	_area.collision_layer = 0
	_area.collision_mask = COLLISION_LAYER_PLAYER
	_area.monitorable = false
	_area.input_ray_pickable = false
	_area.body_entered.connect(_on_player_entered)


func _on_player_entered(player: Player) -> void:
	for camera: PhantomCamera3D in PhantomCameraManager.get_phantom_camera_3ds():
		if camera.get_priority() == PRIORITY_INACTIVE:
			continue

		camera.set_priority(PRIORITY_INACTIVE)

	if config_resource.look_at_enabled:
		_camera.look_at_target = player

	_camera.follow_target = player
	_camera.priority = PRIORITY_ACTIVE
