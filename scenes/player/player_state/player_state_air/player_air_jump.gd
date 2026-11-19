class_name PlayerAirJump
extends PlayerAir

const JUMP_FORCE := 4.0


func enter(data := { }) -> void:
	player.jump_input_buffer.settle()
	player.model.jump()
	var force_strength: float = data.get("force", 1.0)
	player.velocity.y = JUMP_FORCE * force_strength


func _check_changes() -> void:
	_check_ceiling_collisions()

	if player.velocity.y < 0:
		finished.emit(PlayerAirFall)


func _check_ceiling_collisions() -> void:
	if not player.is_on_ceiling():
		return

	for ray_cast in player.ceiling_ray_casts:
		if not ray_cast.is_colliding():
			continue

		var collider := ray_cast.get_collider()
		# Technically not needed since collision mask is only on destroyables,
		# but perhaps future might change that.
		if not collider.is_in_group(GroupConfig.DESTROYABLE):
			continue

		var destroyable: Destroyable = collider
		destroyable.hit()
