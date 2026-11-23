## Base level class. Maximum playable level width is 7m.
class_name BaseLevel
extends Node3D

@onready var _spawn_marker: Marker3D = $SpawnMarker


## Returns spawn marker position.
func get_player_spawn_position() -> Vector3:
	return _spawn_marker.global_position
