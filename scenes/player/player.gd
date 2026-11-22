class_name Player
extends CharacterBody3D

@onready var fsm: StateMachine = $StateMachine
@onready var model: PlayerModel = $Model
@onready var jump_input_buffer: InputBuffer = $JumpInputBuffer
@onready var camera: PlayerCamera = $Camera
@onready var attack_module: PlayerAttackModule = %AttackModule
@onready var turn_toward: TurnToward3D = %TurnToward
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


## Makes player walk towards a certain destination, and enter finish state.
func finish_at(destination: Vector3) -> void:
	fsm.change_state(PlayerFinish, { "destination": destination })


func _on_player_attack_module_attack_requested() -> void:
	model.attack()
