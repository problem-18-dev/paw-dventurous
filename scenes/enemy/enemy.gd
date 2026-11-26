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
@onready var shape: CollisionShape3D = $Shape
@onready var model: Node3D = $Model
@onready var turn_toward: TurnToward3D = $TurnToward3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hitbox: Hitbox3D = $Hitbox3D
@onready var hurtbox: Hurtbox3D = $Hurtbox3D


func _get_configuration_warnings() -> PackedStringArray:
	if positions.is_empty():
		return ["No patrol positions assigned."]
	return []


func _ready() -> void:
	if Engine.is_editor_hint():
		return

	if reverse and positions.size() > 1:
		next_position_pointer = positions.size() - 1
		previous_position_pointer = 0

	fsm.change_state(EnemyTurn)


func flip() -> void:
	if is_flipped:
		animation_player.play(&"bounce")
		return

	fsm.change_state(EnemyFlipped)


func _on_hurtbox_3d_hit_taken(hitbox_taken: Hitbox3D) -> void:
	fsm.change_state(EnemyDead, { "hitbox": hitbox_taken })
