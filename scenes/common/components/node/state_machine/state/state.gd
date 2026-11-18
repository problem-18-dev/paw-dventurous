@abstract
class_name State
extends RefCounted

## Emitted when the state has finished, provides [param next_state].
@warning_ignore("unused_signal")
signal finished(next_state: State)


## Sets parent of state to [param new_parent]. Useful for type-safety.
@abstract func set_parent(new_parent: Node) -> void


## Called upon a state's entry.
func enter(_data := { }) -> void:
	pass


## Called upon a state's exit.
func exit() -> void:
	pass


func _update(_delta: float) -> void:
	pass


func _physics_update(_delta: float) -> void:
	pass


func _unhandled_input(_event: InputEvent) -> void:
	pass
