class_name PlayerIdle
extends PlayerState


func enter(_data := { }) -> void:
	player.velocity = Vector3.ZERO
	player.model.idle()


func _physics_update(_delta: float) -> void:
	_handle_movement()
	player.move_and_slide()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"jump"):
		finished.emit(PlayerAir, { "jump": true })


func _handle_movement() -> void:
	var direction := player.get_direction()

	if not is_zero_approx(direction.length_squared()):
		finished.emit(PlayerWalk)
