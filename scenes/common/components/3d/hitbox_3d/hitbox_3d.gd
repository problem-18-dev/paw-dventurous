## General hitbox component meant for 3D objects.
@tool
@icon("hitbox_3d.svg")
class_name Hitbox3D
extends Area3D

## Emitted when a hit has been detected, provides [param hurtbox].
signal hit(hurtbox: Hurtbox3D)

## Damage to deal when a hit has been detected.
@export var damage := 100
## Only registers a hit once if set to [code]true[/code].
@export var one_shot := false

var _has_hit := false


func _get_configuration_warnings() -> PackedStringArray:
	if get_parent() is not Node3D:
		return ["Hitbox3D must be used with a Node3D."]

	return []


## Only useful if [member one_shot] is set to true. Resets the hit flag.
func reset() -> void:
	_has_hit = false


func _on_area_entered(hurtbox: Hurtbox3D) -> void:
	if (one_shot and _has_hit) or hurtbox.is_invincible:
		return

	_has_hit = true
	hurtbox.take_hit(self)
	hit.emit(hurtbox)
