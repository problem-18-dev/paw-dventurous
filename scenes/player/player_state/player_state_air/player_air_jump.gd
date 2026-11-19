class_name PlayerAirJump
extends PlayerAir

const JUMP_FORCE := 4.0


func enter(_data := { }) -> void:
	player.jump_input_buffer.settle()
	player.model.jump()
	player.velocity.y = JUMP_FORCE


func _check_changes() -> void:
	if player.velocity.y < 0:
		finished.emit(PlayerAirFall)
