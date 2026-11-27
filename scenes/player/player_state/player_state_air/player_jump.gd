class_name PlayerAirJump
extends PlayerAir

const JUMP_HEIGHT := 0.8
const JUMP_CUT_MULTIPLIER := 0.7
const DESTROYABLE_HIT_DOT := 0.8


func enter(data := { }) -> void:
	player.jump_input_buffer.settle()
	player.model.jump()
	var force_strength: float = data.get("force", 1.0)
	player.velocity.y = sqrt(2 * player.get_gravity().length() * JUMP_HEIGHT * force_strength)


func _check_changes() -> void:
	_check_collisions()

	if Input.is_action_just_released(&"jump") and player.velocity.y > 0:
		player.velocity.y *= JUMP_CUT_MULTIPLIER
		return

	if player.velocity.y < 0:
		finished.emit(PlayerAirFall)


func _check_collisions() -> void:
	for i in player.get_slide_collision_count():
		var collision := player.get_slide_collision(i)
		var collider := collision.get_collider()

		if not collider.is_in_group(GroupConfig.DESTROYABLE):
			continue

		# TODO: investigate whether hits should limit to a single one.
		var normal := collision.get_normal()
		if Vector3.DOWN.dot(normal) >= DESTROYABLE_HIT_DOT:
			(collider as Destroyable).hit()
