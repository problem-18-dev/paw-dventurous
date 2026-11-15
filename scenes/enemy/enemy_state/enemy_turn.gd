class_name EnemyTurn
extends EnemyState

const SPEED := TAU / 0.8
const ANGLE_SNAP := deg_to_rad(2.0)


func enter(_data := { }) -> void:
	enemy.velocity = Vector3.ZERO


func _physics_update(delta: float) -> void:
	_turn(delta)
	enemy.move_and_slide()


func _turn(delta: float) -> void:
	var next_position := enemy.positions[enemy.next_position_pointer]
	var direction := enemy.global_position.direction_to(next_position)
	direction.y = 0

	if direction.is_zero_approx():
		finished.emit(EnemyPatrol)
		return

	var new_basis := Basis.looking_at(direction)
	enemy.basis = enemy.basis.slerp(new_basis, SPEED * delta)

	var difference := (-enemy.basis.z).angle_to(direction)
	if difference < ANGLE_SNAP:
		enemy.basis = new_basis
		finished.emit(EnemyPatrol)
