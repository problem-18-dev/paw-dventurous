@tool
class_name Enemy
extends CharacterBody3D

@export var speed := 3.0
@export_group("Patrol")
@export var positions: Array[Vector3] = []
@export var reverse := false

var is_flipped := false
var previous_position_pointer := 0
var next_position_pointer := 0

@onready var fsm: StateMachine = $StateMachine
@onready var turn_toward: TurnToward3D = $TurnToward3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hitbox: Hitbox3D = $Hitbox3D


func _get_configuration_warnings() -> PackedStringArray:
	if positions.is_empty():
		return ["No patrol positions assigned."]
	return []


func _ready() -> void:
	if Engine.is_editor_hint():
		return

	fsm.change_state(EnemyPatrol)


func flip() -> void:
	if is_flipped:
		animation_player.play(&"bounce")
		return

	fsm.change_state(EnemyFlipped)
