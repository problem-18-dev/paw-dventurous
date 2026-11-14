class_name PlayerAir
extends PlayerState

const SPEED := 4.0
const ACCELERATION_WEIGHT := 0.1
const DECELERATION_WEIGHT := 0.1
const JUMP_FORCE := 4.0
const COYOTE_TIME := 0.05

var _is_in_coyote := false


func enter(data := { }) -> void:
	var jump: bool = data.get("jump", false)
	var coyote: bool = data.get("coyote", false)

	if jump:
		_jump()
		return

	if coyote:
		_coyote()


func exit() -> void:
	_is_in_coyote = false
	player.jump_input_buffer.settle()


func _physics_update(delta: float) -> void:
	_apply_gravity(delta)
	_handle_movement()
	_handle_rotation()
	_handle_falling()
	player.move_and_slide()
	_handle_landing()


func _unhandled_input(event: InputEvent) -> void:
	if not _is_in_coyote:
		return

	if event.is_action_pressed(&"jump"):
		_jump()


func _handle_movement() -> void:
	var direction := _get_direction()

	if not is_zero_approx(direction.length_squared()):
		player.velocity.x = move_toward(player.velocity.x, direction.x * SPEED, ACCELERATION_WEIGHT)
		player.velocity.z = move_toward(player.velocity.z, direction.y * SPEED, ACCELERATION_WEIGHT)
		return

	player.velocity.x = move_toward(player.velocity.x, 0, DECELERATION_WEIGHT)
	player.velocity.z = move_toward(player.velocity.z, 0, DECELERATION_WEIGHT)


func _handle_falling() -> void:
	if player.velocity.y < 0:
		player.model.fall()


func _handle_landing() -> void:
	if not player.is_on_floor():
		return

	if player.jump_input_buffer.is_buffered():
		_jump()
		return

	var direction := _get_direction()
	if is_zero_approx(direction.length_squared()):
		finished.emit(PlayerIdle)
	else:
		finished.emit(PlayerWalk)


func _jump() -> void:
	player.model.jump()
	player.velocity.y = JUMP_FORCE


func _coyote() -> void:
	_is_in_coyote = true
	await player.get_tree().create_timer(COYOTE_TIME, false, true).timeout
	_is_in_coyote = false
