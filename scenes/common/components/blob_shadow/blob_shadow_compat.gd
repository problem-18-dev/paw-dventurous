## Renders a blob shadow under the parent. This is the non-decal version for Compatibility renderer.
@tool
class_name BlobShadowCompat
extends Node3D

@export_group("Size")
## How small the blob may get when object is far from the floor.
@export var min_size := 0.4
## How large the blob may get when object is on the floor.
@export var max_size := 1.0

@onready var _ray_cast: RayCast3D = $RayCast3D
@onready var _blob_shadow: MeshInstance3D = $BlobShadow


func _get_configuration_warnings() -> PackedStringArray:
	if not get_parent() or get_parent() is not Node3D:
		return ["Must be child of Node3D."]
	return []


func _ready() -> void:
	var parent := get_parent()
	if Engine.is_editor_hint() or not parent:
		return

	_ray_cast.add_exception(parent)


func _physics_process(_delta: float) -> void:
	if Engine.is_editor_hint():
		return

	_handle_render()
	_adjust_size()


func _handle_render() -> void:
	if not _ray_cast.is_colliding():
		_blob_shadow.hide()
		return

	_blob_shadow.global_position = _ray_cast.get_collision_point()
	_blob_shadow.global_basis = Basis(Quaternion(Vector3.UP, _ray_cast.get_collision_normal()))
	_blob_shadow.show()


func _adjust_size() -> void:
	if not _ray_cast.is_colliding():
		return

	var height := global_position.y - _blob_shadow.global_position.y
	var max_height := absf(_ray_cast.target_position.y)
	var new_scale := clampf(1 - height / max_height, min_size, max_size)
	_blob_shadow.scale = Vector3.ONE * new_scale
