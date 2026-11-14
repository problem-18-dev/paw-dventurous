## Node-less state machine, meant to be used with state script instances.
@icon("state_machine.svg")
class_name StateMachine
extends Node

## Emitted when the state has changed. Returns new [param state].
signal state_changed(state: State)

var _state: State

@onready var parent: Node = get_parent()


func _process(delta: float) -> void:
	if not _state:
		return

	_state._update(delta)


func _physics_process(delta: float) -> void:
	if not _state:
		return

	_state._physics_update(delta)


func _unhandled_input(event: InputEvent) -> void:
	if not _state:
		return

	_state._unhandled_input(event)


## [b]Changes state to newly provided state class script.[/b] [br][br]
## Exits current state, sets parent to new state, enters new state.
func change_state(new_state_class: GDScript, data := { }) -> State:
	if _state:
		_state.exit()
		_state = null

	var new_state: State = new_state_class.new()
	assert(new_state is State, "Invalid state given to state machine.")

	new_state.set_parent(parent)
	new_state.finished.connect(change_state, CONNECT_ONE_SHOT)

	_state = new_state
	_state.enter(data)
	state_changed.emit(_state)

	return _state
