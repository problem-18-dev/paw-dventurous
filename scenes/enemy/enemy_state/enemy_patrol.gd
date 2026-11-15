class_name EnemyPatrol
extends EnemyState


func _physics_update(delta: float) -> void:
	_apply_gravity(delta)

	if not enemy.positions.is_empty():
		_handle_movement(delta)

	enemy.move_and_slide()


func _handle_movement(delta: float) -> void:
	var next_position := enemy.positions[enemy.next_position_pointer]
	var distance := enemy.global_position.distance_to(next_position)
	var snap_distance := enemy.speed * delta
	var is_at_position := distance < snap_distance

	if is_at_position:
		_arrive(next_position)
		return

	var direction := enemy.global_position.direction_to(next_position)
	enemy.velocity.x = direction.x * enemy.speed
	enemy.velocity.z = direction.z * enemy.speed


func _arrive(at_position: Vector3) -> void:
	enemy.global_position = at_position
	enemy.previous_position_pointer = enemy.next_position_pointer
	enemy.next_position_pointer = wrapi(enemy.next_position_pointer + 1, 0, enemy.positions.size())
	finished.emit(EnemyTurn)
