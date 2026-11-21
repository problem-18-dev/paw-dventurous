extends Node

## Emitted when an attack has been requested.
signal attack_requested
## Emitted when attack has finished.
signal finished

@export var cooldown := 0.25

@onready var input_buffer: InputBuffer = $AttackInputBuffer
@onready var attack_cooldown: Timer = $AttackCooldown


func _physics_process(_delta: float) -> void:
	if input_buffer.is_buffered() and attack_cooldown.is_stopped():
		_attack()


func _attack() -> void:
	set_physics_process(false)
	input_buffer.settle()
	attack_cooldown.start(cooldown)
	attack_requested.emit()


func _on_attack_cooldown_timeout() -> void:
	set_physics_process(true)
	finished.emit()
