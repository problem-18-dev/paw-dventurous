extends Area3D

@onready var finish_marker: Marker3D = %FinishMarker
@onready var camera: PhantomCamera3D = $PhantomCamera3D


func _on_body_entered(player: Player) -> void:
	Log.info("Player finished the level!", player)
	player.finish_at(finish_marker.global_position)
	camera.priority = 20
