@abstract
class_name PlayerAir
extends PlayerState

const SPEED := 3.0
const ACCELERATION := SPEED / 0.2
const DECELERATION := SPEED / 0.2


## Applies in-air player gravity, movement, and rotation.
func _physics_update(delta: float) -> void:
	_apply_gravity(delta)
	_handle_movement(delta)
	_handle_rotation()
	player.move_and_slide()
	_check_changes()


## Handle state changes after player's [method move_and_slide] call.
@abstract func _check_changes() -> void


## Handles player movement in-air, to be used for all inheriting [PlayerAir] states.
func _handle_movement(delta: float) -> void:
	var direction := _get_direction()

	if not is_zero_approx(direction.length_squared()):
		player.velocity.x = move_toward(
			player.velocity.x,
			direction.x * SPEED,
			ACCELERATION * delta,
		)
		player.velocity.z = move_toward(
			player.velocity.z,
			direction.y * SPEED,
			ACCELERATION * delta,
		)
		return

	player.velocity.x = move_toward(player.velocity.x, 0, DECELERATION * delta)
	player.velocity.z = move_toward(player.velocity.z, 0, DECELERATION * delta)


## Checks whether player has landed, proceeds to next state based on input.
func _check_landing() -> void:
	if not player.is_on_floor():
		return

	if player.jump_input_buffer.is_buffered():
		finished.emit(PlayerAirJump)
		return

	var direction := _get_direction()
	if is_zero_approx(direction.length_squared()):
		finished.emit(PlayerIdle)
	else:
		finished.emit(PlayerWalk)
