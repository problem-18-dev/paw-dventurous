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

		if collider is Bounceable:
			collider.hit()
			return collider.can_bounce()

	return should_bounce


func _bounce() -> void:
	if Input.is_action_pressed(&"jump"):
		finished.emit(PlayerAirJump, { "force": PlayerAirJump.STRONG_BOUNCE_FORCE })
		return

	finished.emit(PlayerAirJump, { "force": PlayerAirJump.WEAK_BOUNCE_FORCE })
