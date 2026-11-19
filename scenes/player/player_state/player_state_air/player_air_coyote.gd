class_name PlayerAirCoyote
extends PlayerAir

const COYOTE_TIME := 0.05

var _coyote_time_left := COYOTE_TIME


func _check_changes() -> void:
	if player.jump_input_buffer.is_buffered():
		finished.emit(PlayerAirJump)
		return

	_coyote_time_left -= player.get_physics_process_delta_time()
	if _coyote_time_left < 0:
		finished.emit(PlayerAirFall)
