class_name Player
extends CharacterBody3D

@onready var fsm: StateMachine = $StateMachine
@onready var model: PlayerModel = $PlayerModel
@onready var jump_input_buffer: InputBuffer = $JumpInputBuffer
@onready var ceiling_ray_casts: Array[RayCast3D] = [
	$CeilingRayCasts/HeadFrontLeftRayCast,
	$CeilingRayCasts/HeadFrontRightRayCast,
	$CeilingRayCasts/HeadRearLeftRayCast,
	$CeilingRayCasts/HeadRearRightRayCast,
]
@onready var floor_ray_casts: Array[RayCast3D] = [
	$FloorRayCasts/FloorFrontLeftRayCast,
	$FloorRayCasts/FloorFrontRightRayCast,
	$FloorRayCasts/FloorRearLeftRayCast,
	$FloorRayCasts/FloorRearRightRayCast,
]


func _init() -> void:
	add_to_group(GroupConfig.PLAYER)


func _ready() -> void:
	fsm.change_state(PlayerAirFall)


## Returns [Vector2] direction, X is left/right, Y is forward/backward. Negative Y means forward.
func get_direction() -> Vector2:
	return Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
