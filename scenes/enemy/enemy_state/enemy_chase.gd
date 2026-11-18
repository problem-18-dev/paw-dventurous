class_name EnemyChase
extends EnemyState

const TURN_SPEED := TAU / 0.95
const CHASE_SPEED := 2.5
const ACCELERATION := CHASE_SPEED / 0.1
const DECELERATION := CHASE_SPEED / 0.1

var _player: Player


func enter(_data := { }) -> void:
	_player = enemy.get_tree().get_first_node_in_group(GroupConfig.PLAYER)


func _physics_update(delta: float) -> void:
	if not is_instance_valid(_player):
		finished.emit(EnemyPatrol)
		return

	_apply_gravity(delta)
	_look_at_player()
	_move_towards_player(delta)
	enemy.move_and_slide()


func _look_at_player() -> void:
	enemy.turn_toward_3d.turn_toward(_player.global_position, TURN_SPEED)


func _move_towards_player(delta: float) -> void:
	var direction := enemy.global_position.direction_to(_player.global_position)
	var accel := ACCELERATION * delta
	enemy.velocity.x = move_toward(enemy.velocity.x, direction.x * CHASE_SPEED, accel)
	enemy.velocity.z = move_toward(enemy.velocity.z, direction.z * CHASE_SPEED, accel)
