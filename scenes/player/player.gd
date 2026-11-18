class_name Player
extends CharacterBody3D

@onready var fsm: StateMachine = $StateMachine
@onready var model: PlayerModel = $PlayerModel
@onready var jump_input_buffer: InputBuffer = $JumpInputBuffer


func _init() -> void:
	add_to_group(GroupConfig.PLAYER)


func _ready() -> void:
	fsm.change_state(PlayerAir)
