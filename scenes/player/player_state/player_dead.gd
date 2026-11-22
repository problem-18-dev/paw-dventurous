class_name PlayerDead
extends PlayerState


func enter(_data := { }) -> void:
	player.model.die()
