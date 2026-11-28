@tool
class_name ExplosiveCrate
extends Bounceable

const DEFAULT_TRIGGER_DURATION := 3.0

## Duration of countdown towards explosion after trigger.
@export var trigger_duration := DEFAULT_TRIGGER_DURATION

var _triggered := false
var _time_remaining := trigger_duration

@onready var _animation_player: AnimationPlayer = $AnimationPlayer
@onready var _trigger_timer: Timer = $TriggerTimer
@onready var _time_labels: Node3D = $TimeLabels


func can_bounce() -> bool:
	return not _triggered


func hit() -> void:
	_trigger()


func destroy() -> void:
	queue_free()


func _trigger() -> void:
	if _triggered:
		return

	# Defer trigger boolean to let player bounce first.
	set_deferred("_triggered", true)
	_bounce()
	_trigger_timer.start()
	_display_time(_time_remaining)


func _display_time(time: float) -> void:
	_animation_player.play(&"crate_animations/blink")
	for label: Label3D in _time_labels.get_children():
		label.text = str(ceili(time))


func _on_trigger_timer_timeout() -> void:
	_time_remaining -= 1
	_display_time(_time_remaining)

	if _time_remaining <= 0:
		destroy()


func _on_hurtbox_3d_hit_taken(_hitbox: Hitbox3D) -> void:
	destroy()
