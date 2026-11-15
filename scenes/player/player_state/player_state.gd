class_name PlayerState
extends State

var player: Player


func set_parent(new_parent: Node) -> void:
	assert(new_parent is Player, "Player state parent is not Player.")
	player = new_parent


## Returns [Vector2] direction, X is left/right, Y is forward/backward. Negative Y means forward.
func _get_direction() -> Vector2:
	return Input.get_vector("move_left", "move_right", "move_forward", "move_backward")


## Applies gravity when [member player] not on floor.
func _apply_gravity(delta: float) -> void:
	if player.is_on_floor():
		return

	player.velocity.y += player.get_gravity().y * delta


## Handles rotation of model based on input.
func _handle_rotation(weight := 0.25) -> void:
	var direction := _get_direction()

	if is_zero_approx(direction.length_squared()):
		return

	var angle := Basis.looking_at(Vector3(direction.x, 0, direction.y))
	player.basis = player.basis.slerp(angle, weight)
