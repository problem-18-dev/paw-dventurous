class_name PlayerAirFall
extends PlayerAir

const VALID_BOUNCE_THRESHOLD := 0.5


func enter(_data := { }) -> void:
	player.model.fall()


func _check_changes() -> void:
	var should_bounce := _check_collisions()

	if should_bounce:
		_bounce()
	else:
		_check_landing()


## Returns [code]true[/code] if player should bounce.
func _check_collisions() -> bool:
	var should_bounce := false

	for i in player.get_slide_collision_count():
		var collision := player.get_slide_collision(i)
		var collider := collision.get_collider()
		var normal := collision.get_normal()

		if Vector3.UP.dot(normal) < VALID_BOUNCE_THRESHOLD:
			continue

		if collider is FlippableEnemy:
			collider.flip()
			return true

		if collider is Destroyable:
			collider.bounce()
		else:
			continue

		should_bounce = true

	return should_bounce


# TODO: Improve lesser force provide towards jump state.
func _bounce() -> void:
	if Input.is_action_pressed(&"jump"):
		finished.emit(PlayerAirJump, { "force": 1.1 })
		return

	finished.emit(PlayerAirJump, { "force": 0.7 })
