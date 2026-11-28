class_name EnemyDead
extends EnemyState

const HUSS_FORCE := 15.0
const HUSS_RANDOMIZER := 0.5
const HUSS_HEIGHT_MIN := 1.0
const HUSS_HEIGHT_MAX := 2.0
const HUSS_ROTATION := TAU * 2
const DEATH_TIME := 1.0

var _rotation_direction := 1.0


func enter(data := { }) -> void:
	var hitbox: Hitbox3D = data.get("hitbox")

	if not hitbox:
		Log.err("Enemy hurt without hitbox given. Letting enemy turn.")
		finished.emit(EnemyTurn)
		return

	_randomize_rotation()
	_huss(hitbox)
	_disable()
	_destroy()


func _physics_update(delta: float) -> void:
	enemy.model.rotate_y(HUSS_ROTATION * _rotation_direction * delta)
	enemy.move_and_slide()


func _randomize_rotation() -> void:
	_rotation_direction = signf(randf() - 0.5)


func _huss(hitbox: Hitbox3D) -> void:
	var huss_direction := hitbox.global_position.direction_to(enemy.global_position)
	huss_direction.y = 0

	var random := randf_range(-HUSS_RANDOMIZER, HUSS_RANDOMIZER)
	enemy.velocity.x = (huss_direction.x + random) * HUSS_FORCE

	enemy.velocity.y = randf_range(HUSS_HEIGHT_MIN, HUSS_HEIGHT_MAX)

	random = randf_range(-HUSS_RANDOMIZER, HUSS_RANDOMIZER)
	enemy.velocity.z = (huss_direction.z + random) * HUSS_FORCE


func _disable() -> void:
	enemy.shape.set_deferred(&"disabled", true)
	enemy.hitbox.disable()
	enemy.hurtbox.is_invincible = true


func _destroy() -> void:
	var tween := enemy.create_tween()
	tween.tween_property(enemy.model, "scale", Vector3.ONE * 0.5, DEATH_TIME)
	tween.tween_callback(enemy.queue_free)
