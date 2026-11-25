class_name PlayerHurt
extends PlayerAir

const KNOCKBACK_FORCE := 3.0
const PUSHBACK_FORCE := 5.0


func enter(data := { }) -> void:
	var hitbox: Hitbox3D = data.get("hitbox")

	if not hitbox:
		Log.err("Player hurt without hitbox given. Letting player fall.")
		finished.emit(PlayerAirFall)
		return

	_invincible()
	var knockback_direction := hitbox.global_position.direction_to(player.global_position)
	player.velocity.y = KNOCKBACK_FORCE
	player.velocity.x = knockback_direction.x * PUSHBACK_FORCE
	player.velocity.z = knockback_direction.z * PUSHBACK_FORCE

	finished.emit(PlayerAirFall)


func _invincible() -> void:
	player.invincibility_module.enable()
	player.flicker.enable()


func _check_changes() -> void:
	pass
