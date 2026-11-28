class_name PlayerAirJump
extends PlayerAir

const JUMP_HEIGHT := 0.8 # Slightly above the height of two crates.
const JUMP_CUT_MULTIPLIER := 0.7
const WEAK_BOUNCE_FORCE := 0.7
const STRONG_BOUNCE_FORCE := 1.2
const VALID_HIT_THRESHOLD := 0.8

var _already_cut_velocity := false


func enter(data := { }) -> void:
	player.jump_input_buffer.settle()
	player.model.jump()

	var force_strength: float = data.get("force", 1.0)
	_jump(force_strength)


func _check_changes() -> void:
	_check_collisions()

	if Input.is_action_just_released(&"jump"):
		_cut_velocity()
		return

	if player.velocity.y < 0:
		finished.emit(PlayerAirFall)


func _check_collisions() -> void:
	for i in player.get_slide_collision_count():
		var collision := player.get_slide_collision(i)
		var collider := collision.get_collider()
		var normal := collision.get_normal()

		if Vector3.DOWN.dot(normal) < VALID_HIT_THRESHOLD:
			continue

		if collider is Bounceable:
			collider.hit()
			_cut_velocity()
			return


func _cut_velocity() -> void:
	# Checks for negative zero in case of a frame or two.
	if player.velocity.y < 0 or _already_cut_velocity:
		return

	_already_cut_velocity = true
	player.velocity.y *= JUMP_CUT_MULTIPLIER


func _jump(force_strength: float) -> void:
	force_strength = clampf(force_strength, WEAK_BOUNCE_FORCE, STRONG_BOUNCE_FORCE)
	player.velocity.y = sqrt(2 * player.get_gravity().length() * JUMP_HEIGHT * force_strength)
