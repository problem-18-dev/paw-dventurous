class_name PlayerFinish
extends PlayerState

const MOVE_SPEED := 2.5
const MOVE_SNAP := 0.1
const TURN_SPEED := TAU / 0.75
const ANGLE_SNAP := deg_to_rad(2.0)

var _destination: Vector3
var _landed: bool
var _arrived: bool


func enter(data := { }) -> void:
	assert(data.has("destination"), "Finish state entered without destination.")
	_landed = false
	_arrived = false

	var destination: Vector3 = data.get("destination")
	_go_to(destination)


func _physics_update(delta: float) -> void:
	if not _destination or _arrived:
		return

	_correct_model()
	_apply_gravity(delta)
	_handle_movement()
	player.move_and_slide()


func _correct_model() -> void:
	if _landed:
		return

	if player.is_on_floor():
		player.model.walk()
		_landed = true


func _handle_movement() -> void:
	var distance := player.global_position.distance_squared_to(_destination)
	if distance < MOVE_SNAP:
		player.global_position = _destination
		_arrive()
		return

	var direction := player.global_position.direction_to(_destination)
	player.velocity.x = direction.x * MOVE_SPEED
	player.velocity.z = direction.z * MOVE_SPEED

	var new_basis := Basis.looking_at(Vector3(direction.x, 0, direction.z))
	player.basis = player.basis.slerp(new_basis, 0.25)


func _go_to(destination: Vector3) -> void:
	player.attack_module.disable()
	_destination = destination


func _arrive() -> void:
	_arrived = true
	player.model.idle()
	player.turn_toward.turn_toward(Vector3.BACK, TURN_SPEED, ANGLE_SNAP)
	await player.turn_toward.finished
	player.model.sit()
