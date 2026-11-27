@tool
class_name Enemy
extends CharacterBody3D

## How quickly the enemy moves between positions.
@export var speed := 3.0
@export_group("Patrol")
## If [code]true[/code], the enemy will move in reverse order.
@export var reverse := false

## Positions to loop between, if any.
var positions: Array[Vector3] = []
var previous_position_pointer := 0
var next_position_pointer := 0

@onready var fsm: StateMachine = $StateMachine
@onready var shape: CollisionShape3D = $Shape
@onready var model: Node3D = $Model
@onready var turn_toward: TurnToward3D = $TurnToward3D
@onready var hitbox: Hitbox3D = $Hitbox3D


func _get_configuration_warnings() -> PackedStringArray:
	if find_children("*", "Marker3D").is_empty():
		return ["No patrol positions given. Add markers as a child. Order matters!"]
	return []


func _ready() -> void:
	if Engine.is_editor_hint():
		_debug_positions_top_level()
		return

	_collect_positions()
	_initiate_pointer()
	fsm.change_state(EnemyTurn)


## Returns [code]true[/code] if the enemy has more than two positions to loop between.
func should_move() -> bool:
	return not positions.is_empty() or positions.size() > 1


func _debug_positions_top_level() -> void:
	var markers := find_children("*", "Marker3D")
	for marker: Marker3D in markers:
		marker.top_level = true


func _collect_positions() -> void:
	var markers := find_children("*", "Marker3D")
	for marker: Marker3D in markers:
		positions.push_front(marker.global_position)
		marker.queue_free()


func _initiate_pointer() -> void:
	if not should_move():
		return

	previous_position_pointer = positions.size() - 1 if reverse else 0
	next_position_pointer = positions.size() - 1 if reverse else 0
