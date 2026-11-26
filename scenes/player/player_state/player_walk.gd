class_name PlayerWalk
extends PlayerState

const SPEED := 3.5
const ACCELERATION := SPEED / 0.2
const DECELERATION := SPEED / 0.1


func enter(_data := { }) -> void:
	player.model.walk()


func _physics_update(delta: float) -> void:
	_handle_movement(delta)
	_handle_rotation()
	player.move_and_slide()
	_check_floor()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"jump"):
		finished.emit(PlayerAirJump)


func _check_floor() -> void:
	if player.is_on_floor():
		return

	finished.emit(PlayerAirCoyote)


func _handle_movement(delta: float) -> void:
	var direction := _get_direction()

	if not is_zero_approx(direction.length_squared()):
		var new_velocity := Vector3(direction.x, 0, direction.y) * SPEED
		player.velocity = player.velocity.move_toward(new_velocity, ACCELERATION * delta)
		return

	player.velocity = player.velocity.move_toward(Vector3.ZERO, DECELERATION * delta)
	if is_zero_approx(player.velocity.length_squared()):
		finished.emit(PlayerIdle)
