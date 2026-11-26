class_name EnemyPatrol
extends EnemyState

var _next_position: Vector3


func enter(_data := { }) -> void:
	if enemy.positions.is_empty():
		return

	_next_position = enemy.positions[enemy.next_position_pointer]


func _physics_update(delta: float) -> void:
	_apply_gravity(delta)
	_handle_movement(delta)
	enemy.move_and_slide()


func _handle_movement(delta: float) -> void:
	if enemy.positions.is_empty():
		return

	# Only consider horizontal distance, physics should handle hills.
	var enemy_position := Vector2(enemy.global_position.x, enemy.global_position.z)
	var destination := Vector2(_next_position.x, _next_position.z)
	var distance := enemy_position.distance_to(destination)
	var snap_distance := enemy.speed * delta
	var is_at_position := distance < snap_distance

	if is_at_position:
		_arrive()
		return

	var direction := enemy_position.direction_to(destination)
	enemy.velocity.x = direction.x * enemy.speed
	enemy.velocity.z = direction.y * enemy.speed


## Snaps global position to horizontal equivalent of the next position.
func _arrive() -> void:
	enemy.global_position = Vector3(_next_position.x, enemy.global_position.y, _next_position.z)
	enemy.previous_position_pointer = enemy.next_position_pointer
	var next := -1 if enemy.reverse else 1
	enemy.next_position_pointer = wrapi(
		enemy.next_position_pointer + next,
		0,
		enemy.positions.size(),
	)
	finished.emit(EnemyTurn)
