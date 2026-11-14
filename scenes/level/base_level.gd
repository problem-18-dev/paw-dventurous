@abstract
class_name BaseLevel
extends Node3D


## Sets camera target to follow in level.
@abstract func set_camera_target(target: Node3D) -> void


## Returns spawn marker position.
@abstract func get_player_spawn_position() -> Vector3
