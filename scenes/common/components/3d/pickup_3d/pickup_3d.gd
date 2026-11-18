## Simple component to register when an object was picked up.
@tool
@icon("pickup_3d.svg")
class_name Pickup3D
extends Area3D

## Emitted when a body has entered the area.
signal picked_up

@onready var _parent: Node3D = get_parent()


func _get_configuration_warnings() -> PackedStringArray:
	if not is_instance_valid(_parent) or _parent is not Node3D:
		return ["Pickup3D must be a child of Node3D."]

	return []


func _pickup(receiver: Node3D) -> void:
	Log.pr(_parent.name, "picked up by", receiver)


func _on_body_entered(body: Node3D) -> void:
	_pickup(body)
	picked_up.emit()
