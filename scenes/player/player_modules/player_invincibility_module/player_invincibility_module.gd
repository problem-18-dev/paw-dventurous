@tool
class_name PlayerInvinciblityModule
extends Node

## Emitted when invincibility has finished.
signal finished

## How long invincibility lasts.
@export var duration := 1.0
## Which hurtbox to set as invincible.
@export var hurtbox: Hurtbox3D:
	set(value):
		hurtbox = value
		update_configuration_warnings()

@onready var _timer: Timer = $Timer


func _get_configuration_warnings() -> PackedStringArray:
	if not hurtbox:
		return ["No hurtbox selected."]
	return []


## Enables invincibility and starts timer of [member duration].
func enable() -> void:
	hurtbox.is_invincible = true
	_timer.start(duration)


## Disables invincibility, ends timer. Does not emit [signal finished].
func disable() -> void:
	hurtbox.is_invincible = false


func _on_timer_timeout() -> void:
	disable()
	finished.emit()
