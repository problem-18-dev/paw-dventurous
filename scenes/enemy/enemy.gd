@tool
class_name Enemy
extends CharacterBody3D

@export var speed := 3.0
@export_group("Patrol")
@export var positions: Array[Vector3] = []
@export var reverse := false

var previous_position_pointer := 0
var next_position_pointer := 0

@onready var mesh: MeshInstance3D = $MeshInstance3D
@onready var fsm: StateMachine = $StateMachine


func _get_configuration_warnings() -> PackedStringArray:
	if positions.is_empty():
		return ["No patrol positions assigned."]
	return []


func _ready() -> void:
	if Engine.is_editor_hint():
		return

	fsm.change_state(EnemyPatrol)
