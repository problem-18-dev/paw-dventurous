## General hitbox component meant for 3D objects.
@tool
@icon("hitbox_3d.svg")
class_name Hitbox3D
extends Area3D

## Emitted when a hit has been detected, provides [param hurtbox].
signal hit(hurtbox: Hurtbox3D)

## Enables hitbox.
@export var enabled := true


func _get_configuration_warnings() -> PackedStringArray:
	if get_parent() is not Node3D:
		return ["Hitbox3D must be used with a Node3D."]

	return []


## Enables hitbox at end of frame.
func enable() -> void:
	set_deferred(&"enabled", true)


## Disables hitbox at end of frame.
func disable() -> void:
	set_deferred(&"enabled", false)


func _on_area_entered(hurtbox: Hurtbox3D) -> void:
	if not enabled:
		return

	hurtbox.take_hit(self)
	hit.emit(hurtbox)
