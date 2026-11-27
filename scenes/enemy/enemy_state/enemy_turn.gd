class_name EnemyTurn
extends EnemyState

const SPEED := TAU / 0.8
const ANGLE_SNAP := deg_to_rad(2.0)

var _next_position: Vector3


func enter(_data := { }) -> void:
	enemy.velocity = Vector3.ZERO

	if not enemy.should_move():
		return

	_next_position = enemy.positions[enemy.next_position_pointer]
	enemy.turn_toward.finished.connect(finished.emit.bind(EnemyPatrol), CONNECT_ONE_SHOT)
	enemy.turn_toward.turn_toward(_next_position, SPEED, ANGLE_SNAP)


func _physics_update(_delta: float) -> void:
	enemy.move_and_slide()
