class_name PlayerWalk
extends PlayerState

const SPEED := 4.0
const ACCELERATION_WEIGHT := 0.25
const DECELERATION_WEIGHT := 0.5


func enter(_data := { }) -> void:
	player.model.walk()


func _physics_update(_delta: float) -> void:
	_handle_movement()
	_handle_rotation()
	player.move_and_slide()
	_check_floor()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"jump"):
		finished.emit(PlayerAir, { "jump": true })


func _check_floor() -> void:
	if player.is_on_floor():
		return

	finished.emit(PlayerAir, { "coyote": true })


func _handle_movement() -> void:
	var direction := _get_direction()

	if not is_zero_approx(direction.length_squared()):
		var new_velocity := Vector3(direction.x, 0, direction.y) * SPEED
		player.velocity = player.velocity.move_toward(new_velocity, ACCELERATION_WEIGHT)
		return

	player.velocity = player.velocity.move_toward(Vector3.ZERO, DECELERATION_WEIGHT)
	if is_zero_approx(player.velocity.length_squared()):
		finished.emit(PlayerIdle)
