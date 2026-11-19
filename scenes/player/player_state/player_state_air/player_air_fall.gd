class_name PlayerAirFall
extends PlayerAir


func enter(_data := { }) -> void:
	player.model.fall()


func _check_changes() -> void:
	if not player.is_on_floor():
		return

	var can_land := _check_floor_collisions()
	if can_land:
		_check_landing()


## Returns [code]true[/code] if player can land.
func _check_floor_collisions() -> bool:
	var colliding_ray_casts := _colliding_ray_casts()

	if colliding_ray_casts.is_empty():
		return true

	var _has_bounced := false
	for ray_cast in _colliding_ray_casts():
		var collider := ray_cast.get_collider()
		if not collider.is_in_group(GroupConfig.DESTROYABLE):
			continue

		(collider as Destroyable).bounce()
		_has_bounced = true

	if _has_bounced:
		finished.emit(PlayerAirJump, { "force": 0.75 })
	return not _has_bounced


func _check_landing() -> void:
	if player.jump_input_buffer.is_buffered():
		finished.emit(PlayerAirJump)
		return

	var direction := player.get_direction()
	if is_zero_approx(direction.length_squared()):
		finished.emit(PlayerIdle)
	else:
		finished.emit(PlayerWalk)


func _colliding_ray_casts() -> Array[RayCast3D]:
	return player.floor_ray_casts.filter(
		func(r: RayCast3D) -> bool:
			return r.is_colliding(),
	)
