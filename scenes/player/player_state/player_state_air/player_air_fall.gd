class_name PlayerAirFall
extends PlayerAir


func enter(_data := { }) -> void:
	player.model.fall()


func _check_changes() -> void:
	if not player.is_on_floor():
		return

	if player.jump_input_buffer.is_buffered():
		finished.emit(PlayerAirJump)
		return

	var direction := player.get_direction()
	if is_zero_approx(direction.length_squared()):
		finished.emit(PlayerIdle)
	else:
		finished.emit(PlayerWalk)
