class_name PlayerAttackModule
extends Node

## Emitted when an attack has been requested.
signal attack_requested
## Emitted when attack has finished.
signal finished

@export_range(0.1, 1.0) var cooldown := 0.25

@onready var _input_buffer: InputBuffer = $AttackInputBuffer
@onready var _attack_cooldown: Timer = $AttackCooldown


func _physics_process(_delta: float) -> void:
	if _input_buffer.is_buffered() and _attack_cooldown.is_stopped():
		_attack()


## Disables processing, cancels [member _input_buffer] and [member attack_cooldown].
func disable() -> void:
	set_physics_process(false)
	_attack_cooldown.stop()
	_input_buffer.settle()


func _attack() -> void:
	set_physics_process(false)
	_input_buffer.settle()
	_attack_cooldown.start(cooldown)
	attack_requested.emit()


func _on_attack_cooldown_timeout() -> void:
	set_physics_process(true)
	finished.emit()
