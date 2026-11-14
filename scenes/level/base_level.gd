## Base level class. Maximum playable level width is 7m.
class_name BaseLevel
extends Node3D

@onready var spawn_marker: Marker3D = $SpawnMarker3D


## Returns spawn marker position.
func get_player_spawn_position() -> Vector3:
	return spawn_marker.global_position
