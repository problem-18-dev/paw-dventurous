class_name EnemyState
extends State

var enemy: Enemy


func set_parent(new_parent: Node) -> void:
	assert(new_parent is Enemy, "Enemy state parent is not Enemy.")
	enemy = new_parent


## Applies gravity when [member enemy] not on floor.
func _apply_gravity(delta: float) -> void:
	if enemy.is_on_floor():
		return

	enemy.velocity.y += enemy.get_gravity().y * delta
