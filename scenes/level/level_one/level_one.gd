class_name LevelOne
extends BaseLevel

@onready var camera: PhantomCamera3D = $PhantomCamera3D
@onready var spawn_marker: Marker3D = $SpawnMarker3D


func get_player_spawn_position() -> Vector3:
	return spawn_marker.global_position


func set_camera_target(target: Node3D) -> void:
	camera.follow_target = target
