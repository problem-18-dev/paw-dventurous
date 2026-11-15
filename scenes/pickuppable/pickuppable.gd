@tool
class_name Pickuppable
extends Node3D

signal picked_up(type: GameConfig.PickuppableType)

@export var data: PickuppableResource

@onready var mesh: MeshInstance3D = $MeshInstance3D


func _ready() -> void:
	if not data:
		return

	name = data.name
	mesh.mesh = data.mesh


func _on_pickup_3d_picked_up() -> void:
	picked_up.emit(data.type)
	queue_free()
