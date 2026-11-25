## General hurtbox component meant for 3D objects.
@tool
@icon("hurtbox_3d.svg")
class_name Hurtbox3D
extends Area3D

## Emits when a hit was taken, also provides the [param hitbox].
signal hit_taken(hitbox: Hitbox3D)

## If set to [code]true[/code], no hits can be taken.
@export var is_invincible := false


func _get_configuration_warnings() -> PackedStringArray:
	if get_parent() is not Node3D:
		return ["Hurtbox3D must be used with a Node3D."]

	return []


## Registers hit to parent
func take_hit(hitbox: Hitbox3D) -> void:
	if is_invincible:
		return

	hit_taken.emit(hitbox)
